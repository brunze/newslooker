class Issue < ApplicationRecord
  validates :url, presence: true, http_url: true
  validates :title, presence: true

  belongs_to :newsletter
  has_many :links

  def extract_links!(scraper_config: newsletter.scraper_config, html_service: HTTPService.default)
    Scraper
      .new(**scraper_config.deep_symbolize_keys)
      .call(html(html_service:))
      .each do |link_data|
        links.create!(link_data)
      end
  end

  private

  def html(html_service: HTTPService.default)
    @html ||= html_service.get_html(url)
  end
end
