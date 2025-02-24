require "test_helper"

class NewsletterFormComponentTest < ViewComponent::TestCase
  it "shows validation errors and invalid values" do
    newsletter = Newsletter.new(
      name: nil,
      oldest_issue_to_crawl: -2,
    )
    validate_and_render(newsletter)

    assert_text "Name can't be blank"
    assert_text "Oldest issue number to index must be greater than 0"

    newsletter = build(:newsletter, crawler: ArchivePageCrawler.new)
    validate_and_render(newsletter)

    assert_text "URL of the archive page can't be blank"
    assert_text "URL of the archive page must be a HTTP(S) URL"
    assert_text "Issue link selector can't be blank"
    assert_text "Regular expression for issue numbers can't be blank"

    newsletter = build(:newsletter, crawler: URLTemplateCrawler.new)
    validate_and_render(newsletter)

    assert_text "URL template can't be blank"
    assert_text "URL template must be a HTTP(S) URL"

    newsletter = build(:newsletter, scraper: {
      links_scraper: LinksScraper.new(cleanup_regexes: [ "unbalanced[bracked" ])
    })
    validate_and_render(newsletter)

    assert_text "Link block selector can't be blank"
    assert_text "Anchor selector can't be blank"
    assert_text "Blurb selector can't be blank"
    assert_text "Cleanup regular expressions must be a valid regular expression"

    newsletter = build(:newsletter, scraper: {
      publication_date_scraper: NodeAttributePublicationDateScraper.new
    })
    validate_and_render(newsletter)

    assert_text "Node selector can't be blank"
    assert_text "Node attribute name is invalid"

    newsletter = build(:newsletter, scraper: {
      publication_date_scraper: NodeTextPublicationDateScraper.new(
        extractor_regex: "unbalanced[bracket"
      )
    })
    validate_and_render(newsletter)

    assert_text "Node selector can't be blank"
    assert_text "Extractor regular expression must be a valid regular expression"
  end

  private

  def validate_and_render(newsletter)
    newsletter.validate
    render_inline(Backoffice::Newsletters::Form.new(newsletter:))
  end
end
