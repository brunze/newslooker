class URLTemplateCrawler < Crawler
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :kind, :string, default: name
  attribute :url_template, :string

  validates :kind, inclusion: { in: [ name ] }
  validates :url_template, presence: true

  delegate :hash, :as_json, to: :attributes

  def ==(other)
    other.class == self.class && other.attributes == self.attributes
  end

  def crawl(limits: default_crawl_limits, pace: 1.second, http: HTTPService.default)
    issue_numbers_within_limits(limits)
      .lazy
      .map do |number|
        sleep(pace)
        url = Addressable::Template.new(url_template).expand(number:).to_s

        { number:, url: } if http.html_page_exists?(url)
      end
      .take_while { !it.nil? }
  end

  private

  def issue_numbers_within_limits(limits)
    limits => { issue_numbers: { from: Numeric => from, to: Numeric => to } }

    Range.new(from, to)
  end
end
