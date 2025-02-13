class ArchivePageCrawler < Crawler
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :kind, :string, default: "ArchivePageCrawler"
  attribute :archive_page_url, :string
  attribute :issue_link_selector, :string
  attribute :issue_number_regex, :string

  validates :archive_page_url, presence: true, http_url: true
  validates :issue_link_selector, presence: true
  validates :issue_number_regex, presence: true, regexp: true

  def ==(other)
    other.class == self.class && other.attributes == self.attributes
  end

  def hash
    attributes.hash
  end

  def crawl(http: HTTPService.default)
    fetch_archive_page(http)
      .css(issue_link_selector)
      .map { build_issue(it) }
  end

  private

  def build_issue(anchor)
    number = anchor.attr("href").match(issue_number_regex).captures.first.to_i
    url = anchor.attr("href")

    Issue.new(number:, url:)
  end
end
