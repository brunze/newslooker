FactoryBot.define do
  factory :newsletter do
    name do
      subject = Faker::Food.ingredient
      periodicity = %w[Daily Weekly Monthly Quarterly].sample

      "#{subject} #{periodicity}"
    end
    scraper_config
  end
end
