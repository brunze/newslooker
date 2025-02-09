require "test_helper"

class LinkTest < ActiveSupport::TestCase
  describe "factories" do
    test "default factory makes valid links" do
      assert build(:link).valid?
    end
  end

  describe "#fetch_embedding" do
    it "fetches an embedding for the link text and blurb if an embedding doesn't already exist" do
      link = Link.new(
        url: "https://example.com/hello-page",
        text: "This is an Hello!",
        blurb: "Lorem ipsum dolor sit amet."
      )
      assert_nil link.embedding

      mock_embedding = [ 1.0, 2.0, 3.0, 42.0 ]
      embeddings_service_mock = Minitest::Mock.new
      embeddings_service_mock.expect(:fetch, mock_embedding, [ "This is an Hello! Lorem ipsum dolor sit amet." ])

      link.fetch_embedding(embeddings: embeddings_service_mock)

      assert_equal mock_embedding, link.embedding

      link.fetch_embedding(embeddings: embeddings_service_mock)

      embeddings_service_mock.verify
    end

    it "can be forced" do
      initial_embedding = [ 1.0, 2.0, 3.0, 42.0 ]
      link = Link.new(
        url: "https://example.com/hello-page",
        text: "This is an Hello!",
        blurb: "Lorem ipsum dolor sit amet.",
        embedding: initial_embedding
      )

      assert_equal initial_embedding, link.embedding

      second_embedding = [ 9.0, 8.0, 7.0, 0.0 ]
      embeddings_service_mock = Minitest::Mock.new
      embeddings_service_mock.expect(:fetch, second_embedding, [ "This is an Hello! Lorem ipsum dolor sit amet." ])

      link.fetch_embedding(force: true, embeddings: embeddings_service_mock)

      assert_equal second_embedding, link.embedding

      embeddings_service_mock.verify
    end
  end

  describe "#replaces?" do
    it "returns false if the link URLs are not the same" do
      link1 = Link.new(url: "https://example.com/hello-page-1")
      link2 = Link.new(url: "https://example.com/hello-page-2")

      assert_not link1.replaces?(link2)
      assert_not link2.replaces?(link1)
    end
    it "returns true if the text source for embedding is different" do
      url = Faker::Internet.url
      link1 = build(:link, url:, text: "Hello, world!")
      link2 = build(:link, url:, text: "Hello, planet!")

      assert link1.replaces?(link2)
      assert link2.replaces?(link1)

      link3 = build(:link, url:, blurb: "Lorem ipsum dolor sit amet.")
      link4 = build(:link, url:, blurb: "Bacon ipsum dolor amet chicken rump shankle short ribs.")

      assert link3.replaces?(link4)
      assert link4.replaces?(link3)
    end
  end
end
