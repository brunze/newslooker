module Backend
module Crawlers
class ArchivePageCrawlerFields < ViewComponent::Base
  include ::Backend::Form::Controls

  def initialize(crawler: nil, namespace: nil)
    @crawler = crawler || ::ArchivePageCrawler.new
    @namespace = to_namespace(namespace)
  end
  attr_reader :crawler, :namespace

  def call
    text_control(crawler, :archive_page_url, namespace:, required: true) +
    text_control(crawler, :issue_link_selector, namespace:, required: true) +
    text_control(crawler, :issue_number_regex, namespace:, required: true)
  end
end
end
end
