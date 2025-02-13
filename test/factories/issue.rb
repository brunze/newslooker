FactoryBot.define do
  factory :issue do
    newsletter
    sequence(:number)
    url { "https://#{newsletter.name.parameterize}.example.com/issues/#{number}" }
  end
end
