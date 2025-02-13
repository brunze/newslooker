class Crawler < ApplicationRecord
  validates :type, inclusion: { in: %w[UrlTemplateCrawler ArchivePageCrawler] }

  validates :last_crawled_issue_number, numericality: { only_integer: true, greater_than: 0 }, allow_nil: true
  validates :oldest_issue_to_crawl, numericality: { only_integer: true, greater_than: 0 }, allow_nil: true

  def new(attributes)
    case attributes.with_indifferent_access.fetch(:kind).to_s
    in "url_template_crawler" then URLTemplateCrawler.new(attributes)
    in "archive_page_crawler" then ArchivePageCrawler.new(attributes)
    end
  end
end
