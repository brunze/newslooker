module Backend
module Crawlers
class URLTemplateCrawlerFields < ApplicationComponent
  include ::Backend::Form::Controls

  def initialize(crawler: nil, namespace: nil)
    @crawler = crawler || ::URLTemplateCrawler.new
    @namespace = to_namespace(namespace)
  end
  attr_reader :crawler, :namespace

  def call
    text_control(crawler, :url_template, namespace:, required: true)
  end
end
end
end
