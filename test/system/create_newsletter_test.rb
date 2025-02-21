require "application_system_test_case"

class CreateNewsletterTest < ApplicationSystemTestCase
  test "creating a newsletter using valid parameters" do
    newsletter = build(:newsletter)
    assert newsletter.valid?

    visit new_newsletter_url
    fill_in_newsletter_details newsletter
    click_button "Create Newsletter"

    assert_current_path %r{newsletters/\d+}
    assert_newsletter_content newsletter
  end

  test "adding and removing cleanup regexes for the links scraper" do
    newsletter = build(:newsletter)
    newsletter.scraper.links_scraper.cleanup_regexes = [ /foo_rx/, /bar_rx/, /baz_rx/ ]

    visit new_newsletter_url
    fill_in_newsletter_details newsletter

    CleanupRegexesFieldset.new(page).tap do |fieldset|
      fieldset.remove_at(1)
      fieldset.add(/qux_rx/)
    end

    click_button "Create Newsletter"
    assert_current_path %r{newsletters/\d+}

    assert_content "foo_rx"
    assert_content "baz_rx"
    assert_content "qux_rx"
    refute_content "bar_rx"
  end

  private

  def fill_in_newsletter_details(newsletter)
    fill_in "Name", with: newsletter.name
    fill_in "Oldest issue number to index", with: newsletter.oldest_issue_to_crawl
    fill_in_crawler_details newsletter.crawler
    fill_in_scraper_details newsletter.scraper
  end

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

    fill_in_cleanup_regexes ls.cleanup_regexes

    case pds = scraper.publication_date_scraper
    in NodeAttributePublicationDateScraper then fill_in_node_attribute_publication_date_scraper_details(pds)
    in NodeTextPublicationDateScraper then fill_in_node_text_publication_date_scraper_details(pds)
    end
  end

  def fill_in_cleanup_regexes(regexes)
    if regexes&.any?
      CleanupRegexesFieldset.new(page).tap do |fieldset|
        regexes.each { fieldset.add(it) }
      end
    end
  end

  class CleanupRegexesFieldset
    def initialize(page)
      @fieldset = page.find("legend", text: "Cleanup regular expressions").find(:xpath, "..")
      @add_button = @fieldset.find("button", text: "+")
    end
    def add(regex)
      @add_button.click
      @fieldset.all("input").last.fill_in(with: regex.try(:source) || regex.to_s)
    end
    def remove_at(index)
      @fieldset.all("input").to_a[index].sibling("button", text: "❌").click
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

  def assert_newsletter_content(newsletter)
    assert_content newsletter.name
    assert_content "Oldest issue number to index " + newsletter.oldest_issue_to_crawl.to_s

    assert_crawler_content newsletter.crawler
    assert_scraper_content newsletter.scraper
  end

  def assert_crawler_content(crawler)
    case crawler
    in ArchivePageCrawler then assert_archive_page_crawler_content(crawler)
    in URLTemplateCrawler then assert_url_template_crawler_content(crawler)
    end
  end

  def assert_archive_page_crawler_content(crawler)
    assert_content "Type ArchivePageCrawler"
    assert_content crawler.archive_page_url
    assert_content crawler.issue_link_selector
    assert_content crawler.issue_number_regex
  end

  def assert_url_template_crawler_content(crawler)
    assert_content "Type URLTemplateCrawler"
    assert_content crawler.url_template
  end

  def assert_scraper_content(scraper)
    ls = scraper.links_scraper
    assert_content ls.link_block_selector
    assert_content ls.anchor_selector
    assert_content ls.blurb_selector

    ls.cleanup_regexes.each do |regex|
      assert_content regex.source
    end

    case pds = scraper.publication_date_scraper
    in NodeAttributePublicationDateScraper then assert_node_attribute_publication_date_scraper_content(pds)
    in NodeTextPublicationDateScraper then assert_node_text_publication_date_scraper_content(pds)
    end
  end

  def assert_node_attribute_publication_date_scraper_content(scraper)
    assert_content "Type NodeAttributePublicationDateScraper"
    assert_content scraper.node_selector
    assert_content scraper.node_attribute_name
  end

  def assert_node_text_publication_date_scraper_content(scraper)
    assert_content "Type NodeTextPublicationDateScraper"
    assert_content scraper.node_selector
    assert_content scraper.extractor_regex.to_s if scraper.extractor_regex
  end
end
