class ExtractLinksFromIssueJob < ApplicationJob
  queue_as :default

  retry_on EmbeddingsService::ServiceTemporarilyUnavailable, wait: :polynomially_longer, attempts: 10

  def perform(issue)
    issue.extract_links!
  rescue ActiveRecord::RecordNotFound
    # ignore
  end
end
