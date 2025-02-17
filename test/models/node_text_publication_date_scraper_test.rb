require "test_helper"

class NodeTextPublicationDateScraperTest < ActiveSupport::TestCase
  subject { NodeTextPublicationDateScraper }

  describe "validations" do
    it "is invalid without a node selector" do
      assert subject.new(node_selector: nil).invalid?
    end
  end

  it "finds a publication date from the text of any tag in the document" do
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
    scraper = subject.new(
      node_selector: "p.publish-date",
      extractor_regex: "— (\\w+ \\d+, \\d+)\\z",
    )

    publication_date = scraper.call(html)

    assert_equal DateTime.parse("2025-02-06 00:00:00 +0000"), publication_date
  end
end
