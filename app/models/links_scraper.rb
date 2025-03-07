class LinksScraper
  include MiniModel

  attribute :link_block_selector, :string
  attribute :anchor_selector, :string
  attribute :blurb_selector, :string
  attribute :cleanup_regexes, array: true, default: []

  validates :link_block_selector, presence: true
  validates :anchor_selector, presence: true
  validates :blurb_selector, presence: true
  validates :cleanup_regexes, enumerable: { each: { regexp: true } }

  def call(html)
    Scraper.to_nokogiri_doc(html)
      .css(link_block_selector)
      .map(&method(:extract_link_data))
  end

  def extract_link_data(link_block)
    anchor = link_block.css(anchor_selector).first
    url = anchor&.attr("href")
    text = anchor&.text&.squish
    blurb = link_block.css(blurb_selector).first&.text

    clean_up_blurb!(blurb, text) if blurb

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
    cleanup_regexes.map { it.is_a?(Regexp) ? it : Regexp.new(it) }.each { blurb.sub!(it, "") }
  end

  class ActiveRecordType < ActiveRecord::Type::Json
    def cast(value)
      case value
      when NilClass then nil
      when LinksScraper then value
      else LinksScraper.new(value)
      end
    end

    def deserialize(value)
      cast(super(value))
    end
  end

  def self.type
    ActiveRecordType.new
  end
end
