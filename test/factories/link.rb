FactoryBot.define do
  factory :link do
    url { Faker::Internet.url }
    text { Faker::Lorem.sentence }
    issue

    trait :with_blurb do
      blurb { Faker::Lorem.paragraph }
    end

    trait :with_embedding do
      embedding { EmbeddingsService::EMBEDDING_DIMENSIONS.times.map { rand } }
    end
  end
end
