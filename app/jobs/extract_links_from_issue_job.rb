class ExtractLinksFromIssueJob < ApplicationJob
  queue_as :default

  retry_on EmbeddingsService::ServiceTemporarilyUnavailable, wait: :polynomially_longer, attempts: 10

  def perform(issue, ...)
    issue.extract_links!(...)
    fetch_embeddings_where_needed(issue.links)
  rescue ActiveRecord::RecordNotFound
    # ignore
  end

  private

  def fetch_embeddings_where_needed(links)
    links.in_batches(of: 100) do |links|
      jobs = links
        .without_embedding
        .map { FetchEmbeddingForLinkJob.new(it) }

      ActiveJob.perform_all_later(*jobs)
    end
  end
end
