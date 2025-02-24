module Backoffice
module Crawlers
class Fields < ApplicationComponent
  include ::Backoffice::Forms::Helpers

  def initialize(crawler: nil, namespace: nil)
    @crawler = crawler
    @namespace = to_namespace(namespace)
  end
  attr_reader :crawler, :namespace

  def archive_page_crawler = crawler.is_a?(ArchivePageCrawler) ? crawler : nil
  def url_template_crawler = crawler.is_a?(URLTemplateCrawler) ? crawler : nil

  def crawler_kind_selector(**kwargs)
    radio_control(:kind, crawler&.kind, options: kind_radio_options, namespace:, **kwargs)
  end

  def kind_radio_options
    {
      t(".archive_page_crawler") => "ArchivePageCrawler",
      t(".url_template_crawler") => "URLTemplateCrawler"
    }
  end

  def archive_page_crawler_fields
    ArchivePageCrawlerFields.new(crawler: archive_page_crawler, namespace:)
  end

  def url_template_crawler_fields
    URLTemplateCrawlerFields.new(crawler: url_template_crawler, namespace:)
  end
end
end
end
