class Issue < ApplicationRecord
  validates :number, presence: true, numericality: { only_integer: true, greater_than: 0 }, uniqueness: { scope: :newsletter_id }
  validates :url, presence: true, http_url: true, uniqueness: { scope: :newsletter_id }

  belongs_to :newsletter
  has_many :links, dependent: :destroy

  def title
    super || [ newsletter&.name, number ].compact.join(" — ")
  end

  def scraped_links(scraper_config: newsletter.scraper_config, http: HTTPService.default)
    Scraper
      .new(scraper_config)
      .call(http.get_html(url))
      .map { |link_data| Link.new(link_data) }
  end

  def updated_links(new_links = nil, **kwargs)
    new_links ||= scraped_links(**kwargs)
    new_links = new_links.index_by(&:url)
    old_links = self.links.index_by(&:url)

    old_links.merge(new_links) do |_, old_link, new_link|
      new_link.replaces?(old_link) ? new_link : old_link
    end
    .values
  end

  def extract_links!(...)
    links.replace(updated_links(scraped_links(...)))
    nil
  end
end
