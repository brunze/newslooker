class FetchEmbeddingForLinkJob < ApplicationJob
  queue_as :default

  limits_concurrency to: 1, key: "FetchEmbeddingForLinkJob" # same key for everyone ensures everyone queues up behind the same semaphore

  retry_on EmbeddingsService::ServiceTemporarilyUnavailable, wait: :polynomially_longer, attempts: 10
  retry_on HTTPService::Error, wait: 5.minutes, attempts: 3

  def perform(link_id:, **kwargs)
    link = Link.find_by_id(link_id) or return

    link.fetch_embedding!(**kwargs)
  end
end
