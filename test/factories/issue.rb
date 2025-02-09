FactoryBot.define do
  factory :issue do
    transient do
      sequence(:number)
    end

    newsletter
    title { "#{newsletter.name} — Issue #{number}" }
    url { "https://#{newsletter.name.parameterize}.example.com/issues/#{number}" }
  end
end
