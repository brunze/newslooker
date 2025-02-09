require "test_helper"

class IssueTest < ActiveSupport::TestCase
  describe "factories" do
    test "default factory makes valid issues" do
      assert build(:issue).valid?
    end
  end

  describe "#extract_links" do
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
      html_service_mock = Minitest::Mock.new
      html_service_mock.expect(:get_html, mock_html, [ issue.url ])

      scraper_config = {
        link_block_selector: ".link-block",
        link_selector: "a",
        link_blurb_selector: ".blurb"
      }
      issue.extract_links(scraper_config:, html_service: html_service_mock)

      assert_same_set_of_records [
        Link.new(issue:, url: "https://example.com/link-1", text: "Link 1", blurb: "Example blurb 1."),
        Link.new(issue:, url: "https://example.com/link-2", text: "Link 2", blurb: "Example blurb 2."),
        Link.new(issue:, url: "https://example.com/link-3", text: "Link 3", blurb: "Example blurb 3.")
      ], issue.links.to_a, only: [ :issue_id, :url, :text, :blurb ]

      html_service_mock.verify
    end

    it "uses the issue's newsletter scraper config by default" do
      newsletter = build(:newsletter, scraper_config: {
        link_block_selector: ".link-container",
        link_selector: "a.main",
        link_blurb_selector: "p"
      })
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
      html_service_mock = Minitest::Mock.new
      html_service_mock.expect(:get_html, mock_html, [ issue.url ])

      issue.extract_links(html_service: html_service_mock)

      assert_same_set_of_records [
        Link.new(issue:, url: "https://example.com/link-1", text: "Main Link 1", blurb: "Example blurb 1."),
        Link.new(issue:, url: "https://example.com/link-3", text: "Main Link 3", blurb: "Example blurb 3.")
      ], issue.links.to_a, only: [ :issue_id, :url, :text, :blurb ]

      html_service_mock.verify
    end

    it "does what with links already seen? 🤔" do
      skip "# TODO"
    end
  end
end
