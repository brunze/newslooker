require "test_helper"

class ExtractLinksFromIssueJobTest < ActiveJob::TestCase
  it "enqueues jobs to fetch embeddings for new links" do
    issue = create(:issue)
    initial_html = <<~HTML
      <!DOCTYPE html>
      <html>
        <head>
          <meta charset="utf-8">
        </head>
        <body>
          <div class="link-block">
            <a href="https://example.com/link-1">Link 1</a>
            <p class="blurb">Example blurb 1.</p>
          </div>
          <div class="link-block">
            <a href="https://example.com/link-2">Link 2</a>
            <p class="blurb">Example blurb 2.</p>
          </div>
          <div class="link-block">
            <a href="https://example.com/link-3">Link 3</a>
            <p class="blurb">Example blurb 3.</p>
          </div>
        </body>
      </html>
    HTML
    html_service = Minitest::Mock.new
    html_service.expect(:get_html, initial_html, [ issue.url ])

    scraper_config = {
      link_block_selector: ".link-block",
      link_selector: "a",
      link_blurb_selector: ".blurb"
    }

    issue.links << create(:link, :with_embedding, url: "https://example.com/link-2", text: "Link 2", blurb: "Example blurb 2.")
    # 👆 no job should be enqueued for this link because it already has an embedding

    assert_enqueued_jobs(2, only: FetchEmbeddingForLinkJob) do
      ExtractLinksFromIssueJob.new.perform(issue, scraper_config:, html_service:)
    end

    html_service.verify
  end
end
