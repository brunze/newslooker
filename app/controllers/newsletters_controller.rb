class NewslettersController < ApplicationController
  def new
    render Backoffice::Newsletters::Pages::New.new
  end

  def create
    newsletter = Newsletter.new(newsletter_params)

    if newsletter.save
      redirect_to newsletter_url(newsletter)
    else
      render Backoffice::Newsletters::Pages::New.new(newsletter:)
    end
  end

  def show
    newsletter = Newsletter.find(params[:id])

    render Backoffice::Newsletters::Pages::Show.new(newsletter:)
  end

  def edit
    newsletter = Newsletter.find(params[:id])

    render Backoffice::Newsletters::Pages::Edit.new(newsletter:)
  end

  def update
    newsletter = Newsletter.find(params[:id])

    if newsletter.update(newsletter_params)
      redirect_to newsletter_url(newsletter)
    else
      render Backoffice::Newsletters::Pages::Edit.new(newsletter:)
    end
  end

  def index
    newsletters = Newsletter.order(created_at: :desc).limit(100)

    render Backoffice::Newsletters::Pages::Index.new(newsletters:)
  end

  def crawl
    newsletter = Newsletter.find(params[:id])

    CrawlNewsletterJob.perform_later(newsletter_id: newsletter.id)

    redirect_to newsletter_path(newsletter)
  end

  private

  def newsletter_params
    params.expect(newsletter: [ :name, :oldest_issue_to_crawl, crawler: crawler_params, scraper: scraper_params ])
  end

  def crawler_params
    case params.dig(:newsletter, :crawler, :kind)
    when "URLTemplateCrawler" then [ :kind, :url_template ]
    when "ArchivePageCrawler" then [ :kind, :archive_page_url, :issue_link_selector, :issue_number_regex ]
    end
  end

  def scraper_params
    {
      links_scraper: [ :link_block_selector, :anchor_selector, :blurb_selector, cleanup_regexes: [] ],
      publication_date_scraper: publication_date_scraper_params
    }
  end

  def publication_date_scraper_params
    case params.dig(:newsletter, :scraper, :publication_date_scraper, :kind)
    when "NodeAttributePublicationDateScraper" then [ :kind, :node_selector, :node_attribute_name ]
    when "NodeTextPublicationDateScraper" then [ :kind, :node_selector, :extractor_regex ]
    end
  end
end
