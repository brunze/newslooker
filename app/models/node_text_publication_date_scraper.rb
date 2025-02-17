class NodeTextPublicationDateScraper
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :kind, :string, default: name
  attribute :node_selector, :string
  attribute :extractor_regex, :string

  validates :kind, presence: true, inclusion: { in: [ name ] }
  validates :node_selector, presence: true
  validates :extractor_regex, regexp: true, allow_nil: true

  delegate :hash, :as_json, to: :attributes

  def ==(other)
    other.class == self.class && other.attributes == self.attributes
  end

  def call(html)
    Scraper.to_nokogiri_doc(html)
      .css(node_selector).first
      &.text
      &.then(&method(:post_process_text))
      &.then(&DateTime.method(:parse))
  end

  private

  def post_process_text(text)
    if extractor_regex.nil?
      text
    else
      text.match(extractor_regex).captures.first
    end
  end
end
