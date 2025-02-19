module Backend
module Scraper
class LinksScraperFields < ViewComponent::Base
  include ::Backend::Form::Controls

  def initialize(scraper: nil, namespace: nil)
    @scraper = scraper || ::LinksScraper.new
    @namespace = to_namespace(namespace)
  end
  attr_reader :scraper, :namespace
end
end
end
