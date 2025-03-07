class NodeAttributePublicationDateScraper
  include MiniModel

  attribute :kind, :string, default: name
  attribute :node_selector, :string
  attribute :node_attribute_name, :string

  validates :kind, presence: true, inclusion: { in: [ name ] }
  validates :node_selector, presence: true
  validates :node_attribute_name, format: { with: /\A\w+\z/ }

  def call(html)
    Scraper.to_nokogiri_doc(html)
      .css(node_selector).first
      &.attr(node_attribute_name)
      &.then(&DateTime.method(:parse))
  end
end
