module Backoffice
module Issues
module Pages
class Index < Page
  def initialize(issues: nil, next_page_url: nil)
    @issues = issues || []
    @next_page_url = next_page_url
  end
  attr_reader :issues, :next_page_url

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
        ul#issues
          - issues.each do |issue|
            li = link_to issue.title, issue_path(issue)
        #load-more-issues-button
          - if next_page_url
            a.btn href=next_page_url hx-boost="false" script=load_more_issues_script
              = t("load_more")
      SLIM
    end
  end

  def load_more_issues_script
    <<~HYPERSCRIPT
      on click
        halt the event
        fetch `${@href}` as html
          put the <#issues li/> in it at the end of <#issues/>
          put <#load-more-issues-button */> in it into <#load-more-issues-button/>
    HYPERSCRIPT
  end
end
end
end
end
