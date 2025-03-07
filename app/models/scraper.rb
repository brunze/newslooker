class Scraper
  include MiniModel

  attribute :links_scraper, LinksScraper.type
  attribute :publication_date_scraper, PublicationDateScraper.type

  validates :links_scraper, presence: true, nested: true
  validates :publication_date_scraper, presence: true, nested: true

  def call(html)
    html = Scraper.to_nokogiri_doc(html)

    Results.new(
      links: links_scraper.call(html),
      publication_date: publication_date_scraper.call(html)
    )
  end

  private

  def self.to_nokogiri_doc(html)
    html.respond_to?(:css) ? html : Nokogiri::HTML(html)
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
end
