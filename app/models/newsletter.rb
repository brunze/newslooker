class Newsletter < ApplicationRecord
  attribute :scraper_config, :scraper_config
  attribute :crawler, :crawler

  has_many :issues, dependent: :destroy

  validates :name, presence: true
  validates :scraper_config, presence: true, nested: true
  validates :crawler, presence: true, nested: true
  validates :oldest_issue_to_crawl, numericality: { only_integer: true, greater_than: 0 }, allow_nil: true

  def crawl(limits: default_limits_for_next_crawl, crawler: self.crawler, http: HTTPService.default)
    crawler
      .crawl(limits:, http:)
      .reject do |issue_data|
        issue_number = issue_data.fetch(:number)

        issue_number.in?(existing_issue_numbers) ||
        issue_number < oldest_issue_to_crawl
      end
      .map do |issue_data|
        issues.build(issue_data)
      end
  end

  def crawl!(now: Time.current, **kwargs)
    crawl(**kwargs).each(&:save!)
    update!(last_crawled_at: now)
    nil
  end

  def default_limits_for_next_crawl
    lowest_issue_number = existing_issue_numbers.max || oldest_issue_to_crawl
    highest_issue_number = 1_000_000 # effectively infinite but still serializable

    {
      issue_numbers: {
        from: lowest_issue_number,
        to: highest_issue_number
      }
    }
  end

  private

  def existing_issue_numbers
    @existing_issue_numbers ||= issues.pluck(:number)
  end
end
