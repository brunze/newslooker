module Backoffice
module Home
  class RecentLinks < ApplicationComponent
    def initialize(links: [])
      @links = links || []
    end
    attr_reader :links

    slim_template <<~SLIM
      section.RecentLinks
        h3
          span = t(".recent_links")
          a.show-all href=links_path = t("show_all")

        .surface
          - links.each do |link|
            .link
              a href=link.url = link.text
              p.issue = link.issue.title
              p.blurb = link.blurb
    SLIM
  end
end
end
