class Issue < ApplicationRecord
  belongs_to :newsletter
  has_many :links, dependent: :destroy

  validates :number, presence: true, numericality: { only_integer: true, greater_than: 0 }, uniqueness: { scope: :newsletter_id }
  validates :url, presence: true, http_url: true, uniqueness: { scope: :newsletter_id }

  scope :unscraped, -> { where(last_scraped_at: nil) }

  def title
    [ newsletter&.name, number ].compact.join(" — ")
  end

  def scrape!(scraper: newsletter.scraper, now: Time.current, http: HTTPService.default)
    results = scraper.call(http.get_html(self.url))

    extract_links!(results)
    extract_publication_date!(results)
    update!(last_scraped_at: now)
    nil
  end

  def extract_links!(scraper_results)
    scraped_links = scraper_results.links.map { Link.new(it.merge(issue: self)) }
    valid_links = scraped_links.select { it.url.present? && it.text.present? }

    links.replace(updated_links(valid_links))
    nil
  end

  def updated_links(new_links)
    new_links = new_links.index_by(&:url)
    old_links = self.links.index_by(&:url)

    old_links.merge(new_links) do |_, old_link, new_link|
      new_link.replaces?(old_link) ? new_link : old_link
    end
    .values
  end

  def extract_publication_date!(scraper_results)
    update!(published_at: scraper_results.publication_date) if published_at.blank?
  end
end
