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
            = render standard_link(link)
    SLIM

    private

    def standard_link(link)
      Backoffice::Links::StandardLink.new(link:)
    end
  end
end
end
