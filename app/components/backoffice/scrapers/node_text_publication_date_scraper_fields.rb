module Backoffice
module Scrapers
class NodeTextPublicationDateScraperFields < ApplicationComponent
  include ::Backoffice::Forms::Helpers

  def initialize(scraper: nil, namespace: nil)
    @scraper = scraper || ::NodeTextPublicationDateScraper.new
    @namespace = to_namespace(namespace)
  end
  attr_reader :scraper, :namespace

  def call
    text_control(scraper, :node_selector, namespace:, required: true) +
    text_control(scraper, :extractor_regex, namespace:)
  end
end
end
end
