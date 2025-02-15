class Scraper
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :link_block_selector, :string
  attribute :link_selector, :string
  attribute :link_blurb_selector, :string
  attribute :cleanup_regexes, array: true, default: []
  attribute :publish_date_selector, :string
  attribute :publish_date_attribute, :string
  attribute :publish_date_regex, :string

  validates :link_block_selector, presence: true
  validates :link_selector, presence: true
  validates :link_blurb_selector, presence: true
  validates :cleanup_regexes, enumerable: { each: { regexp: true } }
  validates :publish_date_selector, presence: true
  validates :publish_date_attribute, format: { with: /\A\w+\z/ }, allow_nil: true
  validates :publish_date_regex, regexp: true, allow_nil: true

  def ==(other)
    other.class == self.class && other.attributes == self.attributes
  end

  def hash
    attributes.hash
  end

  def call(html)
    html = to_nokogiri_doc(html)

    Results.new(
      links: extract_links(html),
      publication_date: extract_publication_date(html)
    )
  end

  private

  def extract_links(html)
    link_blocks(html).map { extract_link_data(it) }
  end

  def link_blocks(html)
    html.css(link_block_selector)
  end

  def extract_link_data(link_block)
    url = link_block.css(link_selector).first.attr("href")
    text = link_block.css(link_selector).first.text
    blurb = link_block.css(link_blurb_selector).first.text

    clean_up_blurb!(blurb, text)

    { url:, text:, blurb: }
  end

  def clean_up_blurb!(blurb, link_text)
    remove_link_text_from_blurb!(blurb, link_text)
    scrub_with_cleanup_regexes(blurb)
    blurb.squish!

    blurb.blank? ? nil : blurb
  end

  # sometimes it's impossible to avoid this step due to how the HTML is authored
  # if the blurb doesn't repeat the link text then no harm is done anyway
  def remove_link_text_from_blurb!(blurb, link_text)
    blurb.sub!(link_text, "")
  end

  def scrub_with_cleanup_regexes(blurb)
    cleanup_regexes.each { blurb.sub!(it, "") }
  end

  def extract_publication_date(html)
    node = html.css(publish_date_selector).first or return

    date_string = if publish_date_regex
      node.text.match(publish_date_regex).captures.first
    elsif publish_date_attribute
      node.attr(publish_date_attribute)
    else
      raise "Either publish_date_attribute or publish_date_regex must be set" # FIXME error handling
    end

    DateTime.parse(date_string)
  end

  def to_nokogiri_doc(html)
    html.is_a?(Nokogiri::HTML::Document) ? html : Nokogiri::HTML(html)
  end

  Results = Data.define(:links, :publication_date)
end

class Scraper::ActiveRecordType < ActiveRecord::Type::Json
  def cast(value)
    case value
    when NilClass then nil
    when Scraper then value
    else Scraper.new(value)
    end
  end

  def deserialize(value)
    cast(super(value))
  end

  def serialize(value)
    super(value.attributes)
  end
end
