FactoryBot.define do
  factory :node_text_publication_date_scraper do
    skip_create

    node_selector { ".publication-date" }
    extractor_regex { [ nil, %r{(\\w+ \\d+, \\d+)\\z} ].sample }

    trait :invalid do
      node_selector { nil }
      extractor_regex { "unbalanced[bracket" }

      after(:build, &:validate)
    end
  end
end
