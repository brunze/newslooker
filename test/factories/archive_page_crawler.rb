FactoryBot.define do
  factory :archive_page_crawler do
    skip_create

    archive_page_url { "https://#{Faker::Internet.domain_name}.example.com/issues" }
    issue_link_selector { "a" }
    issue_number_regex { /\/issues\/(\d+)/ }

    trait :invalid do
      archive_page_url { "mailto:protocol.not.allowed@example.com" }
      issue_link_selector { nil }
      issue_number_regex { "unbalanced[bracket" }

      after(:build, &:validate)
    end
  end
end
