class Newsletter < ApplicationRecord
  attribute :scraper_config, :scraper_config

  validates :name, presence: true
  validates :scraper_config, presence: true, nested: true
  validates :crawler, nested: true, allow_nil: true

  has_many :issues, dependent: :destroy
  has_one :crawler, dependent: :destroy
end
