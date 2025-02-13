class Newsletter < ApplicationRecord
  attribute :scraper_config, :scraper_config
  attribute :crawler, :crawler

  has_many :issues, dependent: :destroy

  validates :name, presence: true
  validates :scraper_config, presence: true, nested: true
  validates :crawler, presence: true, nested: true
  validates :oldest_issue_to_crawl, numericality: { only_integer: true, greater_than: 0 }, allow_nil: true

end
