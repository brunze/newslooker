require "test_helper"

class NewsletterTest < ActiveSupport::TestCase
  describe "factories" do
    test "default factory makes valid newsletters" do
      assert create(:newsletter).valid?
    end
  end

  describe "validations" do
    it "is invalid without a name" do
      assert build(:newsletter, name: nil).invalid?
    end

    it "is invalid without a scraper configuration" do
      assert build(:newsletter, scraper: nil).invalid?
    end

    it "is invalid without a crawler" do
      assert build(:newsletter, crawler: nil).invalid?
    end
  end

  describe "crawling" do
    it "finds new issues" do
      existing_issues = build_list(:issue, 2)
      new_issues = build_list(:issue, 3)
      newsletter = create(:newsletter, issues: existing_issues)

      all_issues = existing_issues + new_issues
      crawler = simple_stub(crawl: all_issues.map { it.slice(:number, :url) })

      found_issues = newsletter.crawl(crawler:)

      assert_same_attributes new_issues, found_issues, only: %i[number url]
    end

    it "can ignore issues older than a certain issue number" do
      issues = build_list(:issue, 5).sort_by(&:number)
      newer_issues = issues.last(3)
      newsletter = build(:newsletter, oldest_issue_to_crawl: newer_issues.first.number)

      crawler = simple_stub(crawl: issues.map { it.slice(:number, :url) })

      found_issues = newsletter.crawl(crawler:)

      assert_same_attributes newer_issues, found_issues, only: %i[number url]
    end

    it "updates the last crawl timestamp" do
      now = Time.current.beginning_of_minute
      newsletter = create(:newsletter)

      assert_not_equal newsletter.last_crawled_at, now

      crawler = simple_stub(crawl: [])
      newsletter.crawl!(crawler:, now:)

      assert_equal newsletter.last_crawled_at, now
    end
  end
end
