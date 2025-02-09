FactoryBot.define do
  factory :newsletter do
    name do
      subject = Faker::Food.ingredient
      periodicity = %w[Daily Weekly Monthly Quarterly].sample

      "#{subject} #{periodicity}"
    end
    scraper_config { {
      link_block_selector: ".link-block",
      link_selector: "a",
      link_blurb_selector: ".blurb",
      cleanup_regexes: []
    } }
  end
end
