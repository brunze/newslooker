module Backoffice
module Newsletters
class Fields < ApplicationComponent
  include ::Backoffice::Forms::Helpers

  def initialize(newsletter: nil, namespace: nil)
    @newsletter = newsletter || ::Newsletter.new
    @namespace = to_namespace(namespace)
  end
  attr_reader :newsletter, :namespace

  def crawler_fields
    Crawlers::Fields.new(crawler: newsletter.crawler, namespace: namespace[:crawler])
  end

  def scraper_fields
    Scrapers::Fields.new(scraper: newsletter.scraper, namespace: namespace[:scraper])
  end
end
end
end
