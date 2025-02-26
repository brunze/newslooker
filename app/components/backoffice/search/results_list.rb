module Backoffice
module Search
  class ResultsList < ApplicationComponent
    def initialize(links:)
      @links = links
    end
    attr_reader :links

    slim_template <<~SLIM
      .ResultsList
        = header
        .surface
          - if links.any?
            ul
              - links.each do |link|
                li = render standard_link(link)
          - else
            .empty-state ¯\\_(ツ)_/¯
    SLIM

    private

    def header
      tag.h3 t(".n_results_found", count: links.size)
    end

    def standard_link(link)
      Backoffice::Links::StandardLink.new(link:)
    end
  end
end
end
