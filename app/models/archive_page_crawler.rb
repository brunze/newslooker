class ArchivePageCrawler < Crawler
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :kind, :string, default: name
  attribute :archive_page_url, :string
  attribute :issue_link_selector, :string
  attribute :issue_number_regex, :string

  validates :kind, inclusion: { in: [ name ] }
  validates :archive_page_url, presence: true, http_url: true
  validates :issue_link_selector, presence: true
  validates :issue_number_regex, presence: true, regexp: true

  delegate :hash, :as_json, to: :attributes

  def ==(other)
    other.class == self.class && other.attributes == self.attributes
  end

  def crawl(limits: default_crawl_limits, http: HTTPService.default)
    fetch_archive_page(http)
      .css(issue_link_selector)
      .map { gather_issue_data(it) }
      .select(&issue_number_within_limits(limits))
  end

  private

  def fetch_archive_page(http)
    http.get_html(archive_page_url).then { Nokogiri::HTML(it) }
  end

  def gather_issue_data(anchor)
    url = rebase_path(anchor.attr("href")) or raise ExtractionError.new("no `href` found in anchor")
    number = extract_issue_number(url) or raise ExtractionError.new("no issue number found in URL")

    { url:, number: }
  end

  def rebase_path(path)
    if path.nil? || path.to_s.match?(/https?:\/\//)
      path
    else
      base = Addressable::URI.parse(archive_page_url)
      path = Addressable::URI.parse(path)

      base.merge(path.to_hash.compact).to_s
    end
  end

  def extract_issue_number(url)
    url.match(issue_number_regex)&.captures&.first&.to_i
  end

  def issue_number_within_limits(limits)
    limits => { issue_numbers: { from: Numeric => from, to: Numeric => to } }
    issue_range = Range.new(from, to)

    ->(issue_data) { issue_data.fetch(:number).in?(issue_range) }
  end

  class ExtractionError < RuntimeError; end
end
