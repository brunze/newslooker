class NodeTextPublicationDateScraper
  include MiniModel

  attribute :kind, :string, default: name
  attribute :node_selector, :string
  attribute :extractor_regex, :string

  validates :kind, presence: true, inclusion: { in: [ name ] }
  validates :node_selector, presence: true
  validates :extractor_regex, regexp: true, allow_nil: true

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
