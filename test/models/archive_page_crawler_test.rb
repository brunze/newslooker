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
end
