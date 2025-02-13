require "test_helper"

class URLTemplateCrawlerTest < ActiveSupport::TestCase
  describe "factories" do
    test "default factory makes valid crawlers" do
      assert create(:url_template_crawler).valid?
    end
  end

  describe "validations" do
    it "is invalid without a URL template" do
      assert build(:url_template_crawler, url_template: nil).invalid?
    end
  end
end
