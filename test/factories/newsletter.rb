FactoryBot.define do
  factory :newsletter do
    name do
      subject = Faker::Food.ingredient
      periodicity = %w[Daily Weekly Monthly Quarterly].sample

      "#{subject} #{periodicity}"
    end
    scraper_config
    association :crawler, factory: %i[url_template_crawler archive_page_crawler].sample
  end
end
