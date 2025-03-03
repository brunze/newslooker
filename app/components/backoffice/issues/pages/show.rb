module Backoffice
module Issues
module Pages
class Show < Page
  def initialize(issue:, links: nil)
    @issue = issue
    @links = links || []
  end
  attr_reader :issue, :links

  private

  def page_class =  "IssueShowPage"

  def main_content
    render_issue_attributes_surface +
    render_links_surface
  end

  def render_issue_attributes_surface
    render Surface.new do |surface|
      surface.with_heading do
        tag.h1 issue.title
      end
      render issue_attributes
    end
  end

  def issue_attributes
    Backoffice::Issues::Attributes.new(issue:)
  end

  def render_links_surface
    render Surface.new(classes: "IssueLinks") do |surface|
      surface.with_heading do
        tag.h2 t(".issue_links")
      end
      render_list_of_links
    end
  end

  def render_list_of_links
    render ::Backoffice::Links::List.new(
      links:,
      hide: [ :issue ],
      empty_state_message: t(".no_links"),
    )
  end
end
end
end
end
