require "test_helper"

class NewsletterTest < ActiveSupport::TestCase
  describe "factories" do
    test "default factory makes valid newsletters" do
      assert build(:newsletter).valid?
    end
  end
end
