class HomeController < ApplicationController
  def show
    render Backoffice::Home::HomePage.new(
      recent_links:,
      recent_issues:,
    )
  end

  private

  def recent_links
    Link.order(created_at: :desc).includes(issue: [ :newsletter ]).limit(25).to_a.sample(5)
  end

  def recent_issues
    Issue.order(created_at: :desc).includes(:newsletter).limit(10).to_a
  end
end
