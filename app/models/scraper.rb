class Scraper
  def initialize(link_block_selector:, link_selector:, link_blurb_selector:, cleanup_regexes: [])
    @link_block_selector = link_block_selector.to_str
    @link_selector = link_selector.to_str
    @link_blurb_selector = link_blurb_selector.to_str
    @cleanup_regexes = cleanup_regexes.map { Regexp.new(it) }
  end

  def call(html)
    link_blocks(to_nokogiri_doc(html)).map do |link_block|
      extract_link_data(link_block)
    end
  end

  private

  def link_blocks(html)
    html.css(@link_block_selector)
  end

  def extract_link_data(link_block)
    url = link_block.css(@link_selector).first.attr("href")
    text = link_block.css(@link_selector).first.text
    blurb = link_block.css(@link_blurb_selector).first.text

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
    @cleanup_regexes.each { blurb.sub!(it, "") }
  end

  def to_nokogiri_doc(html)
    html.is_a?(Nokogiri::HTML::Document) ? html : Nokogiri::HTML(html)
  end
end
