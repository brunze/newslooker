class ScrapeIssueJob < ApplicationJob
  queue_as :default

  def perform(issue_id:, **kwargs)
    issue = Issue.find_by_id(issue_id) or return

    issue.scrape!(**kwargs)
    fetch_embeddings_where_needed(issue)
  end

  private

  def fetch_embeddings_where_needed(issue)
    issue.links.without_embedding.in_batches(of: 100) do |links|
      ActiveJob.perform_all_later(
        *links.map { FetchEmbeddingForLinkJob.new(link_id: it.id) }
      )
    end
  end
end
