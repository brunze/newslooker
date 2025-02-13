FactoryBot.define do
  factory :archive_page_crawler do
    newsletter
    archive_page_url { "https://#{newsletter.name.parameterize}.example.com/issues" }
    issue_link_selector { "a" }
    issue_number_regex { /\/issues\/(\d+)/ }
  end
end
