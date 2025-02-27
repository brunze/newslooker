module Backoffice
module Home
  class RecentLinks < ApplicationComponent
    def initialize(links: [])
      @links = links || []
    end
    attr_reader :links

    private

    def standard_link(link)
      Backoffice::Links::StandardLink.new(link:)
    end
  end
end
end
