ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

require "minitest/mock"

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers.
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    # fixtures :all

    # Add more helper methods to be used by all tests here...
    include FactoryBot::Syntax::Methods

    # Check if two collections contain the same objects, comparing by attributes and ignoring order.
    def assert_same_attributes(expected, actual, only: [])
      get_attributes = ->(record) { only.empty? ? record.attributes : record.slice(*only) } >> :symbolize_keys.to_proc

      assert_equal expected.to_set(&get_attributes), actual.to_set(&get_attributes)
    end
  end
end
