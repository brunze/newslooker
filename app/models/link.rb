class Link < ApplicationRecord
  validates :url, presence: true, http_url: true
  validates :text, presence: true

  belongs_to :issue

  has_neighbors :embedding

  def self.similar_to(needle, limit: 10, embeddings: EmbeddingsService.default)
    needle_embedding = embeddings.fetch(needle.to_str)
    self.nearest_neighbors(:embedding, needle_embedding, distance: "euclidean").first(limit)
  end

  def fetch_embedding(embeddings: EmbeddingsService.default)
    embeddings.fetch(source_for_embeddings)
  end

  def fetch_embedding!(embeddings: EmbeddingsService.default)
    update!(embedding: fetch_embedding(embeddings:)) if embedding.blank?
    nil
  end

  private

  def source_for_embeddings
    "#{text} #{blurb}".squish
  end
end
