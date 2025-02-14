require "test_helper"

class IssueTest < ActiveSupport::TestCase
  describe "factories" do
    test "default factory makes valid issues" do
      assert create(:issue).valid?
    end
  end

  describe "validations" do
    it "is invalid without a URL" do
      assert build(:issue, url: nil).invalid?
    end

    it "is invalid if the URL is not unique, per newsletter" do
      issue = create(:issue)

      assert build(:issue, url: issue.url, newsletter: issue.newsletter).invalid?
      assert build(:issue, url: issue.url, newsletter: build(:newsletter)).valid?
    end

    it "is invalid without a number" do
      assert build(:issue, number: nil).invalid?
    end

    it "is invalid if the number is not unique, per newsletter" do
      issue = create(:issue)

      assert build(:issue, number: issue.number, newsletter: issue.newsletter).invalid?
      assert build(:issue, number: issue.number, newsletter: build(:newsletter)).valid?
    end
  end

  describe "scraping" do
    it "extracts a publication date" do
      skip "# TODO"
    end

    it "extracts links" do
      issue = create(:issue)
      links_extracted = false

      issue.stub(:extract_links!, proc { links_extracted = true }) do
        issue.scrape!
      end

      assert links_extracted # link extraction tested more thoroughly below
    end

    it "updates the last_scraped_at timestamp" do
      issue = create(:issue)
      now = Time.current.beginning_of_minute

      issue.stub(:extract_links!, nil) do
        issue.scrape!(now:)
      end

      assert issue.last_scraped_at, now
    end
  end

  describe "link extraction" do
    it "it fetches the HTML for the issue and builds the relevant Links it finds in it" do
      issue = build(:issue)

      mock_html = <<~HTML
        <!DOCTYPE html>
        <html>
          <head>
            <meta charset="utf-8">
          </head>
          <body>
            <div class="link-block">
              <a href="https://example.com/link-1">Link 1</a>
              <p class="blurb">Example blurb 1.</p>
            </div>
            <div class="link-block">
              <a href="https://example.com/link-2">Link 2</a>
              <p class="blurb">Example blurb 2.</p>
            </div>
            <div class="link-block">
              <a href="https://example.com/link-3">Link 3</a>
              <p class="blurb">Example blurb 3.</p>
            </div>
          </body>
        </html>
      HTML
      http_service_mock = Minitest::Mock.new
      http_service_mock.expect(:get_html, mock_html, [ issue.url ])

      scraper_config = ScraperConfig.new(
        link_block_selector: ".link-block",
        link_selector: "a",
        link_blurb_selector: ".blurb"
      )
      issue_links = issue.updated_links(scraper_config:, http: http_service_mock)

      assert_same_attributes [
        Link.new(issue:, url: "https://example.com/link-1", text: "Link 1", blurb: "Example blurb 1."),
        Link.new(issue:, url: "https://example.com/link-2", text: "Link 2", blurb: "Example blurb 2."),
        Link.new(issue:, url: "https://example.com/link-3", text: "Link 3", blurb: "Example blurb 3.")
      ], issue_links.to_a, only: [ :url, :text, :blurb ]

      http_service_mock.verify
    end

    it "uses the issue's newsletter scraper config by default" do
      newsletter = build(:newsletter, scraper_config: ScraperConfig.new(
        link_block_selector: ".link-container",
        link_selector: "a.main",
        link_blurb_selector: "p"
      ))
      issue = build(:issue, newsletter:)

      mock_html = <<~HTML
        <!DOCTYPE html>
        <html>
          <head>
            <meta charset="utf-8">
          </head>
          <body>
            <div class="link-container">
              <a href="https://example.com/ignored-link-1">Ignored Link 1</a>
              <a class="main" href="https://example.com/link-1">Main Link 1</a>
              <p>Example blurb 1.</p>
            </div>
            <div class="link-block">
              <a href="https://example.com/link-2">Link 2</a>
              <p class="blurb">Example blurb 2.</p>
            </div>
            <div class="link-container">
              <a href="https://example.com/ignored-link-3">Ignored Link 3</a>
              <a class="main" href="https://example.com/link-3">Main Link 3</a>
              <p>Example blurb 3.</p>
            </div>
          </body>
        </html>
      HTML
      http_service_mock = Minitest::Mock.new
      http_service_mock.expect(:get_html, mock_html, [ issue.url ])

      issue_links = issue.updated_links(http: http_service_mock)

      assert_same_attributes [
        Link.new(issue:, url: "https://example.com/link-1", text: "Main Link 1", blurb: "Example blurb 1."),
        Link.new(issue:, url: "https://example.com/link-3", text: "Main Link 3", blurb: "Example blurb 3.")
      ], issue_links.to_a, only: [ :url, :text, :blurb ]

      http_service_mock.verify
    end

    describe "when it encounters a link that had already been previously extracted" do
      it "replaces the existing link if it has a different text or blurb" do
        issue = build(:issue)

        mock_html = <<~HTML
          <!DOCTYPE html>
          <html>
            <head>
              <meta charset="utf-8">
            </head>
            <body>
              <div class="link-block">
                <a href="https://example.com/link-1">Link 1</a>
                <p class="blurb">Example blurb 1.</p>
              </div>
              <div class="link-block">
                <a href="https://example.com/link-2">Link 2</a>
                <p class="blurb">Example blurb 2.</p>
              </div>
              <div class="link-block">
                <a href="https://example.com/link-3">Link 3</a>
                <p class="blurb">Example blurb 3.</p>
              </div>
            </body>
          </html>
        HTML
        http_service_mock = Minitest::Mock.new
        http_service_mock.expect(:get_html, mock_html, [ issue.url ])

        scraper_config = ScraperConfig.new(
          link_block_selector: ".link-block",
          link_selector: "a",
          link_blurb_selector: ".blurb"
        )
        issue.updated_links(scraper_config:, http: http_service_mock)

        modified_mock_html = <<~HTML
          <!DOCTYPE html>
          <html>
            <head>
              <meta charset="utf-8">
            </head>
            <body>
              <div class="link-block">
                <a href="https://example.com/link-1">Link 1, different text</a>
                <p class="blurb">Example blurb 1.</p>
              </div>
              <div class="link-block">
                <a href="https://example.com/link-2">Link 2</a>
                <p class="blurb">Example blurb 2, different blurb.</p>
              </div>
              <div class="link-block">
                <a href="https://example.com/link-3">Link 3</a>
                <p class="blurb">Example blurb 3.</p>
              </div>
            </body>
          </html>
        HTML
        http_service_mock.expect(:get_html, modified_mock_html, [ issue.url ])

        updated_links = issue.updated_links(scraper_config:, http: http_service_mock)

        assert_same_attributes [
          Link.new(issue:, url: "https://example.com/link-1", text: "Link 1, different text", blurb: "Example blurb 1."),
          Link.new(issue:, url: "https://example.com/link-2", text: "Link 2", blurb: "Example blurb 2, different blurb."),
          Link.new(issue:, url: "https://example.com/link-3", text: "Link 3", blurb: "Example blurb 3.")
        ], updated_links, only: [ :url, :text, :blurb ]

        http_service_mock.verify
      end
    end

    it "preserves old links even if they disappear from the issue's HTML page" do
      issue = build(:issue)

      mock_html = <<~HTML
        <!DOCTYPE html>
        <html>
          <head>
            <meta charset="utf-8">
          </head>
          <body>
            <div class="link-block">
              <a href="https://example.com/link-1">Link 1</a>
              <p class="blurb">Example blurb 1.</p>
            </div>
            <div class="link-block">
              <a href="https://example.com/link-2">Link 2</a>
              <p class="blurb">Example blurb 2.</p>
            </div>
            <div class="link-block">
              <a href="https://example.com/link-3">Link 3</a>
              <p class="blurb">Example blurb 3.</p>
            </div>
          </body>
        </html>
      HTML
      http_service_mock = Minitest::Mock.new
      http_service_mock.expect(:get_html, mock_html, [ issue.url ])

      scraper_config = ScraperConfig.new(
        link_block_selector: ".link-block",
        link_selector: "a",
        link_blurb_selector: ".blurb"
      )
      issue.extract_links!(scraper_config:, http: http_service_mock)

      assert_same_attributes [
        Link.new(issue:, url: "https://example.com/link-1", text: "Link 1", blurb: "Example blurb 1."),
        Link.new(issue:, url: "https://example.com/link-2", text: "Link 2", blurb: "Example blurb 2."),
        Link.new(issue:, url: "https://example.com/link-3", text: "Link 3", blurb: "Example blurb 3.")
      ], issue.links.to_a, only: [ :url, :text, :blurb ]

      http_service_mock.verify

      modified_html = <<~HTML
        <!DOCTYPE html>
        <html>
          <head>
            <meta charset="utf-8">
          </head>
          <body>
            <div class="link-block">
              <a href="https://example.com/link-2">Link 2</a>
              <p class="blurb">Example blurb 2.</p>
            </div>
          </body>
        </html>
      HTML
      http_service_mock.expect(:get_html, modified_html, [ issue.url ])

      issue.extract_links!(scraper_config:, http: http_service_mock)

      assert_same_attributes [
        Link.new(issue:, url: "https://example.com/link-1", text: "Link 1", blurb: "Example blurb 1."),
        Link.new(issue:, url: "https://example.com/link-2", text: "Link 2", blurb: "Example blurb 2."),
        Link.new(issue:, url: "https://example.com/link-3", text: "Link 3", blurb: "Example blurb 3.")
      ], issue.links.to_a, only: [ :url, :text, :blurb ]

      http_service_mock.verify
    end
  end
end
