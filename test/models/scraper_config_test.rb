require "test_helper"

class ScraperConfigTest < ActiveSupport::TestCase
  describe "factories" do
    test "default factory makes valid scraper configurations" do
      assert build(:scraper_config).valid?
    end
  end

  describe "defaults" do
    it "starts with an empty set of cleanup regular expressions" do
      assert build(:scraper_config).cleanup_regexes.empty?
    end
  end

  describe "validations" do
    it "is invalid without a link block selector" do
      assert build(:scraper_config, link_block_selector: nil).invalid?
    end

    it "is invalid without a link selector" do
      assert build(:scraper_config, link_selector: nil).invalid?
    end

    it "is invalid without a link blurb selector" do
      assert build(:scraper_config, link_blurb_selector: nil).invalid?
    end

    it "is invalid without cleanup regular expressions" do
      assert build(:scraper_config, cleanup_regexes: nil).invalid?
    end

    it "is invalid if any of the cleanup regular expressions is not a valid regular expression" do
      assert build(:scraper_config, cleanup_regexes: [ nil ]).invalid?
      assert build(:scraper_config, cleanup_regexes: [ "[" ]).invalid?
    end
  end
end
