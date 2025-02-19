module Backend
module Scraper
class Fields < ViewComponent::Base
  include ::Backend::Form::Controls

  def initialize(scraper: nil, namespace: nil)
    @scraper = scraper || ::Scraper.new
    @namespace = to_namespace(namespace)
  end
  attr_reader :scraper, :namespace

  def links_scraper_fields
    LinksScraperFields.new(scraper: scraper.links_scraper, namespace: namespace[:links_scraper])
  end

  def publication_date_scraper_fields
    PublicationDateScraperFields.new(scraper: scraper.publication_date_scraper, namespace: namespace[:publication_date_scraper])
  end
end
end
end
