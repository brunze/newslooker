FactoryBot.define do
  factory :issue do
    newsletter
    sequence(:number)
    title { "#{newsletter.name} — ##{number}" }
    url { "https://#{newsletter.name.parameterize}.example.com/issues/#{number}" }
    published_at { 1.week.ago }
  end
end
