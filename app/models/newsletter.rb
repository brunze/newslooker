class Newsletter < ApplicationRecord
  validates :name, presence: true
  validates :scraper_config, presence: true

  has_many :issues, dependent: :destroy
end
