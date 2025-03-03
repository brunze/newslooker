module Backoffice
module Home
  class RecentLinks < ApplicationComponent
    def initialize(links: [])
      @links = links || []
    end
    attr_reader :links
  end
end
end
