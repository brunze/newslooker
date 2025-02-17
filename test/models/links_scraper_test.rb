require "test_helper"

class LinksScraperTest < ActiveSupport::TestCase
  subject { LinksScraper }

  describe "defaults" do
    it "starts with an empty set of cleanup regular expressions" do
      assert subject.new.cleanup_regexes.empty?
    end
  end

  describe "validations" do
    it "is invalid without a link block selector" do
      assert subject.new(link_block_selector: nil).invalid?
    end

    it "is invalid without an anchor selector" do
      assert subject.new(anchor_selector: nil).invalid?
    end

    it "is invalid without a blurb selector" do
      assert subject.new(blurb_selector: nil).invalid?
    end

    it "is invalid without cleanup regular expressions" do
      assert subject.new(cleanup_regexes: nil).invalid?
    end

    it "is invalid if any of the cleanup regular expressions is not a valid regular expression" do
      assert subject.new(cleanup_regexes: [ nil ]).invalid?
      assert subject.new(cleanup_regexes: [ "[" ]).invalid?
    end
  end

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
      scraper = subject.new(
        link_block_selector: ".link-block",
        anchor_selector: "a",
        blurb_selector: ".blurb"
      )

      link_data = scraper.call(html)

      assert_equal [
        { url: "https://example.com/link-1", text: "Link 1", blurb: "Example blurb 1." },
        { url: "https://example.com/link-2", text: "Link 2", blurb: "Example blurb 2." },
        { url: "https://example.com/link-3", text: "Link 3", blurb: "Example blurb 3." }
      ].to_set, link_data.to_set
  end
end
