class CrawlNewsletterJob < ApplicationJob
  queue_as :default

  limits_concurrency to: 1, key: proc { it.id }

  def perform(newsletter_id:, **kwargs)
    newsletter = Newsletter.find_by_id(newsletter_id) or return

    newsletter.crawl!(**kwargs)
    scrape_new_issues(newsletter)
  end

  private

  def scrape_new_issues(newsletter)
    newsletter.issues.unscraped.in_batches(of: 100) do |issues|
      ActiveJob.perform_all_later(
        *issues.map { ScrapeIssueJob.new(issue_id: it.id) }
      )
    end
  end
end
