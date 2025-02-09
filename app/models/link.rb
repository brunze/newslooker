class Link < ApplicationRecord
  validates :url, presence: true, http_url: true
  validates :text, presence: true

  belongs_to :issue

  has_neighbors :embedding

  def self.similar_to(needle, limit: 10, embeddings: EmbeddingsService.default)
    needle_embedding = embeddings.fetch(needle.to_str)
    self.nearest_neighbors(:embedding, needle_embedding, distance: "euclidean").first(limit)
  end

  def fetch_embedding(force: false, embeddings: EmbeddingsService.default)
    self.embedding = embeddings.fetch(source_for_embeddings) if embedding.nil? || force
    nil
  end

  def fetch_embedding!(...)
    fetch_embedding(...)
    update!(embedding:)
    nil
  end

  private

  def source_for_embeddings
    "#{text} #{blurb}".squish
  end
end
