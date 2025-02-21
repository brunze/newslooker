module Backend
module Scraper
class PublicationDateScraperFields < ApplicationComponent
  include ::Backend::Form::Controls

  def initialize(scraper: nil, namespace: nil)
    @scraper = scraper
    @namespace = to_namespace(namespace)
  end
  attr_reader :scraper, :namespace

  def node_attribute_publication_date_scraper =
    scraper.is_a?(NodeAttributePublicationDateScraper) ? scraper : nil

  def node_text_publication_date_scraper =
    scraper.is_a?(NodeTextPublicationDateScraper) ? scraper : nil

  def scraper_kind_selector(**kwargs)
    radio_control(:kind, scraper&.kind, options: kind_radio_options, namespace:, **kwargs)
  end

  def kind_radio_options
    {
      t(".node_attribute_publication_date_scraper") => "NodeAttributePublicationDateScraper",
      t(".node_text_publication_date_scraper") => "NodeTextPublicationDateScraper"
    }
  end

  def node_attribute_publication_date_scraper_fields
    NodeAttributePublicationDateScraperFields.new(scraper: node_attribute_publication_date_scraper, namespace:)
  end

  def node_text_publication_date_scraper_fields
    NodeTextPublicationDateScraperFields.new(scraper: node_text_publication_date_scraper, namespace:)
  end
end
end
end
