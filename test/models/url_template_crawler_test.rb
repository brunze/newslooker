require "test_helper"

class URLTemplateCrawlerTest < ActiveSupport::TestCase
  describe "factories" do
    test "default factory makes valid crawlers" do
      assert create(:url_template_crawler).valid?
    end
  end

  describe "validations" do
    it "is invalid without a URL template" do
      assert build(:url_template_crawler, url_template: nil).invalid?
    end
  end

  describe "crawl" do
    it "returns a lazy sequence" do
      Timeout.timeout(3) do
        crawler = build(:url_template_crawler)

        issues = crawler.crawl

        assert_instance_of Enumerator::Lazy, issues
      end
    end

    it "tries finding issues based on the URL template and a range of issue numbers" do
      crawler = build(:url_template_crawler, url_template: "https://example.com/issues/{number}")
      http = simple_stub(html_page_exists?: true)

      issues = crawler.crawl(limits: { issue_numbers: { from: 8, to: 11 } }, pace: 0, http:).first(10)

      assert_equal [
        { number: 8, url: "https://example.com/issues/8" },
        { number: 9, url: "https://example.com/issues/9" },
        { number: 10, url: "https://example.com/issues/10" },
        { number: 11, url: "https://example.com/issues/11" }
      ], issues
    end

    it "stops on the first URL for which it cannot find an issue" do
      crawler = build(:url_template_crawler, url_template: "https://example.com/issues/{number}")

      http = simple_stub(html_page_exists?: ->(url) { url != "https://example.com/issues/10" })

      issues = crawler.crawl(limits: { issue_numbers: { from: 8, to: 11 } }, pace: 0, http:).first(10)

      assert_equal [
        { number: 8, url: "https://example.com/issues/8" },
        { number: 9, url: "https://example.com/issues/9" }
      ], issues
    end

    it "starts with issue number 1 by default" do
      crawler = build(:url_template_crawler, url_template: "https://example.com/issues/{number}")
      http = simple_stub(html_page_exists?: true)

      issues = crawler.crawl(pace: 0, http:).take(3).to_a

      assert_equal [
        { number: 1, url: "https://example.com/issues/1" },
        { number: 2, url: "https://example.com/issues/2" },
        { number: 3, url: "https://example.com/issues/3" }
      ], issues
    end
  end
end
