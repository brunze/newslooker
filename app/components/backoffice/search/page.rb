module Backoffice
module Search
  class Page < ::Backoffice::Page
    def initialize(links:, needle:)
      @links = links
      @needle = needle
    end
    attr_reader :links, :needle

    private

    def main_content
      render(HeroSearch.new(needle:)) +
      render(ResultsList.new(links:))
    end
  end
end
end
