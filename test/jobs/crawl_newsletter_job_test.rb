require "test_helper"

class CrawlNewsletterJobTest < ActiveJob::TestCase
  it "enqueues jobs to scrape new issues" do
    newsletter = create(:newsletter)

    # 👇 no job should be enqueued for this issue because it was already scraped
    newsletter.issues << create(:issue, :scraped, number: 1, url: "https://example.com/link-1")
    newsletter.issues << create(:issue, number: 2, url: "https://example.com/link-2")

    crawler = simple_stub(crawl: [
      { number: 1, url: "https://example.com/link-1" },
      { number: 2, url: "https://example.com/link-2" },
      { number: 3, url: "https://example.com/link-3" },
      { number: 4, url: "https://example.com/link-4" }
    ])

    CrawlNewsletterJob.new.perform(newsletter_id: newsletter.id, crawler:)

    issues_to_scrape = newsletter.issues.where("number > 1")

    assert_enqueued_jobs(issues_to_scrape.count, only: ScrapeIssueJob)

    issues_to_scrape.each do |issue|
      assert_enqueued_with(job: ScrapeIssueJob, args: [ { issue_id: issue.id } ])
    end
  end
end
