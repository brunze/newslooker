require "test_helper"

class ScraperTest < ActiveSupport::TestCase
  describe "factories" do
    test "default factory makes valid scraper configurations" do
      assert build(:scraper).valid?
    end
  end

  describe "defaults" do
    it "starts with an empty set of cleanup regular expressions" do
      assert build(:scraper).cleanup_regexes.empty?
    end
  end

  describe "validations" do
    it "is invalid without a link block selector" do
      assert build(:scraper, link_block_selector: nil).invalid?
    end

    it "is invalid without a link selector" do
      assert build(:scraper, link_selector: nil).invalid?
    end

    it "is invalid without a link blurb selector" do
      assert build(:scraper, link_blurb_selector: nil).invalid?
    end

    it "is invalid without cleanup regular expressions" do
      assert build(:scraper, cleanup_regexes: nil).invalid?
    end

    it "is invalid if any of the cleanup regular expressions is not a valid regular expression" do
      assert build(:scraper, cleanup_regexes: [ nil ]).invalid?
      assert build(:scraper, cleanup_regexes: [ "[" ]).invalid?
    end
  end

  describe "finding a publication date" do
    it "finds a publication date using a meta tag" do
      html = <<~HTML
        <!DOCTYPE html>
        <html>
          <head>
            <meta charset="utf-8">
            <meta property="article:published_time" content="2025-02-04 16:00:00 +0200">
          </head>
          <body></body>
        </html>
      HTML
      scraper = build(:scraper,
        publish_date_selector: "meta[property='article:published_time']",
        publish_date_attribute: "content"
      )

      results = scraper.call(html)

      assert_equal DateTime.parse("2025-02-04 14:00:00 +0000"), results.publication_date
    end

    it "finds a publication date using any tag in the document" do
      html = <<~HTML
        <!DOCTYPE html>
        <html>
          <head><meta charset="utf-8"></head>
          <body>
            <p>Hello, world!</p>
            <p class="publish-date">#737 — February 6, 2025</p>
            <p>Goodbye, world!</p>
          </body>
        </html>
      HTML
      scraper = build(:scraper,
        publish_date_selector: "p.publish-date",
        publish_date_regex: "— (\\w+ \\d+, \\d+)\\z"
      )

      results = scraper.call(html)

      assert_equal DateTime.parse("2025-02-06 00:00:00 +0000"), results.publication_date
    end
  end

  describe "finding links" do
    it "finds links using CSS selectors" do
      html = <<~HTML
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
        scraper = build(:scraper,
          link_block_selector: ".link-block",
          link_selector: "a",
          link_blurb_selector: ".blurb"
        )

        results = scraper.call(html)

        assert_equal [
          { url: "https://example.com/link-1", text: "Link 1", blurb: "Example blurb 1." },
          { url: "https://example.com/link-2", text: "Link 2", blurb: "Example blurb 2." },
          { url: "https://example.com/link-3", text: "Link 3", blurb: "Example blurb 3." }
        ].to_set, results.links.to_set
    end
  end
end
