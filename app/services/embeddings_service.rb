class EmbeddingsService
  MAX_SOURCE_TEXT_LENGTH = 1500
  EMBEDDING_DIMENSIONS = 1024

  def self.default
    @default_instance ||= self.new
  end

  def fetch(source_text)
    client
      .embeddings({
        model: "mistral-embed",
        input: [ source_text.truncate(MAX_SOURCE_TEXT_LENGTH) ]
      })
      .dig("data", 0, "embedding")
  rescue Faraday::TooManyRequestsError
    raise ServiceTemporarilyUnavailable
  end

  private

  def client
    @client ||= Mistral.new(
      credentials: { api_key: ENV.fetch("MISTRAL_API_KEY") },
    )
  end

  class ServiceTemporarilyUnavailable < RuntimeError; end
end
