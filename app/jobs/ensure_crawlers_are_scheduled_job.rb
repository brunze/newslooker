class EnsureCrawlersAreScheduledJob < ApplicationJob
  queue_as :default

  def perform
    Newsletter.find_each do
      CrawlNewsletterJob.set(wait: small_delay).perform_later(newsletter_id: it.id)
    end
  end

  private

  def small_delay
    (0..20).sample.minutes
  end
end
