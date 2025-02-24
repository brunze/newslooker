FactoryBot.define do
  factory :links_scraper do
    skip_create

    link_block_selector { ".link-block" }
    anchor_selector { "a" }
    blurb_selector { ".blurb" }
    cleanup_regexes { (0..4).to_a.sample.times.map { Regexp.new(Faker::Lorem.word) } }

    trait :invalid do
      link_block_selector { nil }
      anchor_selector { nil }
      blurb_selector { nil }
      cleanup_regexes { (1..3).to_a.sample.times.map { "unbalanced[#{Faker::Lorem.word}" } }

      after(:build, &:validate)
    end
  end
end
