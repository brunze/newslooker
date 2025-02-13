FactoryBot.define do
  factory :url_template_crawler do
    skip_create

    url_template { "https://#{Faker::Internet.domain_name}/issues/{number}" }
  end
end
