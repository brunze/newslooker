require "application_system_test_case"

class CreateNewsletterTest < ApplicationSystemTestCase
  test "creating a newsletter using valid parameters" do
    visit new_newsletter_url

    newsletter = build(:newsletter)
    assert newsletter.valid?

    fill_in "Name", with: newsletter.name
    fill_in "Oldest issue number to index", with: newsletter.oldest_issue_to_crawl
    fill_in_crawler_details newsletter.crawler
    fill_in_scraper_details newsletter.scraper
    click_button "Create Newsletter"

    assert_content newsletter.name
    # FIXME check the remaining attributes were saved correctly too
  end

  private

  def fill_in_crawler_details(crawler)
    case crawler
    in ArchivePageCrawler then fill_in_archive_page_crawler_details(crawler)
    in URLTemplateCrawler then fill_in_url_template_crawler_details(crawler)
    end
  end

  def fill_in_archive_page_crawler_details(crawler)
    choose "Archive page crawler"
    fill_in "URL of the archive page", with: crawler.archive_page_url
    fill_in "Issue link selector", with: crawler.issue_link_selector
    fill_in "Regular expression for issue numbers", with: crawler.issue_number_regex
  end

  def fill_in_url_template_crawler_details(crawler)
    choose "URL template crawler"
    fill_in "URL template", with: crawler.url_template
  end

  def fill_in_scraper_details(scraper)
    ls = scraper.links_scraper
    fill_in "Link block selector", with: ls.link_block_selector
    fill_in "Anchor selector", with: ls.anchor_selector
    fill_in "Blurb selector", with: ls.blurb_selector

    case pds = scraper.publication_date_scraper
    in NodeAttributePublicationDateScraper then fill_in_node_attribute_publication_date_scraper_details(pds)
    in NodeTextPublicationDateScraper then fill_in_node_text_publication_date_scraper_details(pds)
    end
  end

  def fill_in_node_attribute_publication_date_scraper_details(scraper)
    choose "Get publication date from an HTML tag's attribute value"
    fill_in "Node selector", with: scraper.node_selector
    fill_in "Node attribute name", with: scraper.node_attribute_name
  end

  def fill_in_node_text_publication_date_scraper_details(scraper)
    choose "Get publication date from an HTML tag's content"
    fill_in "Node selector", with: scraper.node_selector
    fill_in "Extractor regular expression", with: scraper.extractor_regex
  end
end
