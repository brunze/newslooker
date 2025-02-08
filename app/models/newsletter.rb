class Newsletter < ApplicationRecord
  validates :name, presence: true
  validates :scraper_config, presence: true

  has_many :issues
end
