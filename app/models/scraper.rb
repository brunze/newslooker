class Scraper
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :link_block_selector, :string
  attribute :link_selector, :string
  attribute :link_blurb_selector, :string
  attribute :cleanup_regexes, array: true, default: []

  validates :link_block_selector, presence: true
  validates :link_selector, presence: true
  validates :link_blurb_selector, presence: true
  validates :cleanup_regexes, enumerable: { each: { regexp: true } }

  def ==(other)
    other.class == self.class && other.attributes == self.attributes
  end

  def hash
    attributes.hash
  end

  def call(html)
    link_blocks(to_nokogiri_doc(html)).map do |link_block|
      extract_link_data(link_block)
    end
  end

  private

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

  def to_nokogiri_doc(html)
    html.is_a?(Nokogiri::HTML::Document) ? html : Nokogiri::HTML(html)
  end
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
