require "test_helper"

class NewsletterTest < ActiveSupport::TestCase
  describe "factories" do
    test "default factory makes valid newsletters" do
      assert create(:newsletter).valid?
    end
  end

  describe "validations" do
    it "is invalid without a name" do
      assert build(:newsletter, name: nil).invalid?
    end

    it "is invalid without a scraper configuration" do
      assert build(:newsletter, scraper_config: nil).invalid?
    end
  end
end
