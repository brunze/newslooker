class ScraperConfig
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :link_block_selector, :string
  attribute :link_selector, :string
  attribute :link_blurb_selector, :string
  attribute :cleanup_regexes, array: true, default: []

  validates :link_block_selector, presence: true
  validates :link_selector, presence: true
  validates :link_blurb_selector, presence: true
  validates :cleanup_regexes, enumerable: { each: { regexp: true } }

  def ==(other)
    other.class == self.class && other.attributes == self.attributes
  end

  def hash
    attributes.hash
  end
end

class ScraperConfig::ActiveRecordType < ActiveRecord::Type::Json
  def cast(value)
    case value
    when NilClass then nil
    when ScraperConfig then value
    else ScraperConfig.new(value)
    end
  end
end
