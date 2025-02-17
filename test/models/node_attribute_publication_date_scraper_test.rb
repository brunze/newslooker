require "test_helper"

class NodeAttributePublicationDateScraperTest < ActiveSupport::TestCase
  subject { NodeAttributePublicationDateScraper }

  describe "validations" do
    it "is invalid without a node selector" do
      assert subject.new(node_selector: nil).invalid?
    end

    it "is invalid without a node attribute name" do
      assert subject.new(node_attribute_name: nil).invalid?
    end
  end

  it "finds a publication date stored in a node attribute value" do
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
    scraper = subject.new(
      node_selector: "meta[property='article:published_time']",
      node_attribute_name: "content"
    )

    publication_date = scraper.call(html)

    assert_equal DateTime.parse("2025-02-04 14:00:00 +0000"), publication_date
  end
end
