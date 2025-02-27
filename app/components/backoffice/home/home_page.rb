module Backoffice
module Home
  class HomePage < Page
    def initialize(recent_links: [], recent_issues: [])
      @recent_links = recent_links
      @recent_issues = recent_issues
    end

    private

    def page_class = "HomePage"

    def top_nav_options
      super.deep_merge({ current: :home })
    end

    def main_content
      render(HeroSearch.new) +
      render(RecentLinks.new(links: @recent_links)) +
      render(RecentIssues.new(issues: @recent_issues))
    end
  end
end
end
