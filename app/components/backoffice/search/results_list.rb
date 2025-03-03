module Backoffice
module Search
  class ResultsList < ApplicationComponent
    def initialize(links:)
      @links = links
    end
    attr_reader :links
  end
end
end
