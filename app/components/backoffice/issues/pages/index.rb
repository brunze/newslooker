module Backoffice
module Issues
module Pages
class Index < Page
  def initialize(issues: nil)
    @issues = issues || []
  end
  attr_reader :issues

  private

  def page_class =  "IssueIndexPage"

  def main_content
    render Surface.new do |surface|
      surface.with_heading do
        tag.h1 Issue.model_name.human.pluralize
      end
      render_issues_list
    end
  end

  def render_issues_list
    if issues.any?
      render_slim <<~SLIM
        ul
          - issues.each do |issue|
            li = link_to issue.title, issue_path(issue)
      SLIM
    end
  end
end
end
end
end
