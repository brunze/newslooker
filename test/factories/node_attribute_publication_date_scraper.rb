FactoryBot.define do
  factory :node_attribute_publication_date_scraper do
    skip_create

    node_selector { "meta[property='article:published_time']" }
    node_attribute_name { "content" }

    trait :invalid do
      node_selector { nil }
      node_attribute_name { nil }

      after(:build, &:validate)
    end
  end
end
