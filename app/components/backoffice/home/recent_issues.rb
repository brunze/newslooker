module Backoffice
module Home
  class RecentIssues < ApplicationComponent
    def initialize(issues: [])
      @issues = issues || []
    end
    attr_reader :issues

    slim_template <<~SLIM
      section.RecentIssues
        h3
          span = t(".recent_issues")
          a.show-all href=issues_path = t("show_all")

        .issues
          - issues.each do |issue|
            a href=issue_path(issue) = issue.title
    SLIM
  end
end
end
