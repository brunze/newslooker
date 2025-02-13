FactoryBot.define do
  factory :archive_page_crawler do
    skip_create

    archive_page_url { "https://#{Faker::Internet.domain_name}.example.com/issues" }
    issue_link_selector { "a" }
    issue_number_regex { /\/issues\/(\d+)/ }
  end
end
