class URLTemplateCrawler < Crawler
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :kind, :string, default: "URLTemplateCrawler"
  attribute :url_template, :string

  validates :url_template, presence: true

  def ==(other)
    other.class == self.class && other.attributes == self.attributes
  end

  def hash
    attributes.hash
  end

  def crawl(issue_numbers:)
    issue_numbers.map do |number|
      url = Addressable::Template.new(url_template).expand(number:).to_s

      Issue.new(number:, url:)
    end
  end
end
