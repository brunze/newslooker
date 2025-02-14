class Link < ApplicationRecord
  belongs_to :issue

  has_neighbors :embedding

  validates :url, presence: true, http_url: true, uniqueness: { scope: :issue_id }
  validates :text, presence: true

  scope :without_embedding, -> { where(embedding: nil) }

  def self.similar_to(needle, limit: 10, embeddings: EmbeddingsService.default)
    needle_embedding = embeddings.fetch(needle.to_str)
    self.nearest_neighbors(:embedding, needle_embedding, distance: "euclidean").first(limit)
  end

  def fetch_embedding!(...)
    fetch_embedding(...)
    update!(embedding:)
    nil
  end

  def fetch_embedding(force: false, embeddings: EmbeddingsService.default)
    self.embedding = embeddings.fetch(source_for_embeddings) if embedding.nil? || force
    nil
  end

  def source_for_embeddings
    "#{text} #{blurb}".squish
  end

  def replaces?(other)
    self.url == other.url && self.source_for_embeddings != other.source_for_embeddings
  end
end
