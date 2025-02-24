FactoryBot.define do
  factory :url_template_crawler do
    skip_create

    url_template { "https://#{Faker::Internet.domain_name}/issues/{number}" }

    trait :invalid do
      url_template { "mailto:protocol.not.allowed@example.com" }

      after(:build, &:validate)
    end
  end
end
