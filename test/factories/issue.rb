FactoryBot.define do
  factory :issue do
    newsletter
    sequence(:number)
    url { "https://#{newsletter.name.parameterize}.example.com/issues/#{number}" }

    trait :scraped do
      last_scraped_at { 1.day.ago }
    end
  end
end
