class IssuesController < ApplicationController
  def index
    pagy, issues = pagy_keyset(
      Issue.order(created_at: :desc, id: :desc).includes(:newsletter),
      tuple_comparison: true,
    )

    render Backoffice::Issues::Pages::Index.new(issues:, next_page_url: pagy_keyset_next_url(pagy))
  end

  def show
    issue = Issue.find(params[:id])
    links = issue.links.order(created_at: :asc).limit(100) # newsletters don't typically have hundreds of links

    render Backoffice::Issues::Pages::Show.new(issue:, links:)
  end

  def scrape
    issue = Issue.find(params[:id])

    ScrapeIssueJob.perform_later(issue_id: issue.id)

    redirect_to issue_path(issue)
  end
end
