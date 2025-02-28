class IssuesController < ApplicationController
  def index
    issues = Issue.order(created_at: :desc).limit(100)

    render Backoffice::Issues::Pages::Index.new(issues:)
  end

  def show
    issue = Issue.find(params[:id])
    links = issue.links.limit(100) # TODO pagination

    render Backoffice::Issues::Pages::Show.new(issue:, links:)
  end
end
