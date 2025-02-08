class FetchEmbeddingForLinkJob < ApplicationJob
  queue_as :default

  retry_on HTTPService::Error, wait: 5.minutes, attempts: 3

  def perform(link)
    link.fetch_embedding!
  rescue ActiveRecord::RecordNotFound
    # ignore
  end
end
