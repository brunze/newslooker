class Newsletter < ApplicationRecord
  attribute :scraper_config, :scraper_config

  validates :name, presence: true
  validates :scraper_config, presence: true, nested: true

  has_many :issues, dependent: :destroy
end
