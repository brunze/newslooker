FactoryBot.define do
  factory :newsletter do
    name do
      subject = Faker::Food.ingredient
      periodicity = %w[Daily Weekly Monthly Quarterly].sample

      "#{subject} #{periodicity}"
    end
    oldest_issue_to_crawl { (rand * 1000).ceil }
    scraper
    association :crawler, factory: %i[url_template_crawler archive_page_crawler].sample

    trait :invalid do
      name { nil }
      oldest_issue_to_crawl { -1 }
      scraper { nil }
      crawler { nil }

      after(:build, &:validate)
    end
  end
end
