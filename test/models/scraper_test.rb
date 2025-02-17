require "test_helper"

class ScraperTest < ActiveSupport::TestCase
  describe "factories" do
    test "default factory makes valid scrapers" do
      assert build(:scraper).valid?
    end
  end

  describe "validations" do
    it "is invalid without a scraper for links" do
      assert build(:scraper, links_scraper: nil).invalid?
    end

    it "is invalid without a scraper for a publication date" do
      assert build(:scraper, publication_date_scraper: nil).invalid?
    end
  end

  it "finds links and a publication date" do
    scraper = build(:scraper)

    results = scraper.call("<html><head><meta charset='utf-8'></head><body></body></html>")

    assert results.respond_to?(:links)
    assert results.respond_to?(:publication_date)
  end
end
