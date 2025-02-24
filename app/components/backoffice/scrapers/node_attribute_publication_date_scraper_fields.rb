module Backoffice
module Scrapers
class NodeAttributePublicationDateScraperFields < ApplicationComponent
  include ::Backoffice::Forms::Helpers

  def initialize(scraper: nil, namespace: nil)
    @scraper = scraper || ::NodeAttributePublicationDateScraper.new
    @namespace = to_namespace(namespace)
  end
  attr_reader :scraper, :namespace

  def call
    text_control(scraper, :node_selector, namespace:, required: true) +
    text_control(scraper, :node_attribute_name, namespace:, required: true)
  end
end
end
end
