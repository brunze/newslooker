class NodeAttributePublicationDateScraper
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :kind, :string, default: name
  attribute :node_selector, :string
  attribute :node_attribute_name, :string

  validates :kind, presence: true, inclusion: { in: [ name ] }
  validates :node_selector, presence: true
  validates :node_attribute_name, format: { with: /\A\w+\z/ }

  delegate :hash, :as_json, to: :attributes

  def ==(other)
    other.class == self.class && other.attributes == self.attributes
  end

  def call(html)
    Scraper.to_nokogiri_doc(html)
      .css(node_selector).first
      &.attr(node_attribute_name)
      &.then(&DateTime.method(:parse))
  end
end
