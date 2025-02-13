class URLTemplateCrawler < Crawler
  belongs_to :newsletter

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
