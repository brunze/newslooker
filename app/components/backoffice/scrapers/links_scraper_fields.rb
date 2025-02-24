module Backoffice
module Scrapers
class LinksScraperFields < ApplicationComponent
  include ::Backoffice::Forms::Helpers

  def initialize(scraper: nil, namespace: nil)
    @scraper = scraper || ::LinksScraper.new
    @namespace = to_namespace(namespace)
  end
  attr_reader :scraper, :namespace

  def cleanup_regex_input(regex = "")
    tag.input type: "text", name: namespace[:cleanup_regexes][], value: regex
  end
end
end
end
