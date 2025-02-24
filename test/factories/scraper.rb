FactoryBot.define do
  factory :scraper do
    skip_create

    links_scraper
    association :publication_date_scraper, factory: %i[
      node_attribute_publication_date_scraper
      node_text_publication_date_scraper
    ].sample

    trait :invalid do
      links_scraper { nil }
      publication_date_scraper { nil }

      after(:build, &:validate)
    end
  end
end
