module Backoffice
module Home
  class RecentIssues < ApplicationComponent
    def initialize(issues: [])
      @issues = issues || []
    end
    attr_reader :issues
  end
end
end
