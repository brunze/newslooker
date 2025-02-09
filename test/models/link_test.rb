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
end
