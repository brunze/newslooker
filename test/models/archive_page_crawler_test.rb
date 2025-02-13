require "test_helper"

class ArchivePageCrawlerTest < ActiveSupport::TestCase
  describe "factories" do
    test "default factory makes valid crawlers" do
      assert build(:archive_page_crawler).valid?
    end
  end

  describe "validations" do
    it "is invalid without a URL to an archive page" do
      assert_not build(:archive_page_crawler, archive_page_url: nil).valid?
    end

    it "is invalid without a selector to find the links to issues" do
      assert_not build(:archive_page_crawler, issue_link_selector: nil).valid?
    end

    it "is invalid without a regular expression to extract the issue number from the issue links" do
      assert_not build(:archive_page_crawler, issue_number_regex: nil).valid?
    end
  end

  describe "crawl" do
    it "finds all issues listed in the archive page" do
      crawler = build(:archive_page_crawler,
        issue_link_selector: "a.issue",
        issue_number_regex: /\/issues\/(\d+)/
      )

      archive_page_html = <<~HTML
        <!DOCTYPE html>
        <html>
          <head><meta charset="utf-8"></head>
          <body>
            <a class="issue" href="https://example.com/issues/3">Lorem Ipsum #3</a>
            <a class="issue" href="https://example.com/issues/2">Lorem Ipsum #2</a>
            <a class="issue" href="https://example.com/issues/1">Lorem Ipsum #1</a>
          </body>
        </html>
      HTML
      http_service_mock = Minitest::Mock.new
      http_service_mock.expect(:get_html, archive_page_html, [ crawler.archive_page_url ])

      issues = crawler.crawl(http: http_service_mock)

      assert_equal [
        { number: 1, url: "https://example.com/issues/1" },
        { number: 2, url: "https://example.com/issues/2" },
        { number: 3, url: "https://example.com/issues/3" }
      ].to_set, issues.to_set

      http_service_mock.verify
    end

    it "can limit the issues return to just those with an issue number within a given range" do
      crawler = build(:archive_page_crawler,
        issue_link_selector: "a.issue",
        issue_number_regex: /\/issues\/(\d+)/
      )

      archive_page_html = <<~HTML
        <!DOCTYPE html>
        <html>
          <head><meta charset="utf-8"></head>
          <body>
            <a class="issue" href="https://example.com/issues/5">Lorem Ipsum #5</a>
            <a class="issue" href="https://example.com/issues/4">Lorem Ipsum #4</a>
            <a class="issue" href="https://example.com/issues/3">Lorem Ipsum #3</a>
            <a class="issue" href="https://example.com/issues/2">Lorem Ipsum #2</a>
            <a class="issue" href="https://example.com/issues/1">Lorem Ipsum #1</a>
          </body>
        </html>
      HTML
      http_service_mock = Minitest::Mock.new
      http_service_mock.expect(:get_html, archive_page_html, [ crawler.archive_page_url ])

      issues = crawler.crawl(limits: { issue_numbers: { from: 2, to: 4 } }, http: http_service_mock)

      assert_equal [
        { number: 2, url: "https://example.com/issues/2" },
        { number: 3, url: "https://example.com/issues/3" },
        { number: 4, url: "https://example.com/issues/4" }
      ].to_set, issues.to_set

      http_service_mock.verify
    end
  end
end
