require "factory_bot_rails"

class NewsletterFormComponentPreview < ViewComponent::Preview
  include FactoryBot::Syntax::Methods

  def blank
    render form(Newsletter.new)
  end

  def invalid
    render_with_template(locals: {
      invalid_top_level_attributes: form(build(:newsletter, :invalid)),
      invalid_archive_page_crawler: form(build(:newsletter, crawler: build(:archive_page_crawler, :invalid))),
      invalid_url_template_crawler: form(build(:newsletter, crawler: build(:url_template_crawler, :invalid))),
      invalid_scraper: form(build(:newsletter, scraper: build(:scraper, :invalid))),
      invalid_links_scraper: form(build(:newsletter, scraper: {
        links_scraper: build(:links_scraper, :invalid)
      })),
      invalid_node_attribute_publication_date_scraper: form(build(:newsletter, scraper: {
        publication_date_scraper: build(:node_attribute_publication_date_scraper, :invalid)
      })),
      invalid_node_text_publication_date_scraper: form(build(:newsletter, scraper: {
        publication_date_scraper: build(:node_text_publication_date_scraper, :invalid)
      }))
    })
  end

  private

  def form(newsletter)
    Backend::Newsletters::Form.new(newsletter:)
  end
end
