FactoryBot.define do
  factory :scraper_config do
    skip_create

    link_block_selector { ".link-block" }
    link_selector { "a" }
    link_blurb_selector { ".blurb" }
    cleanup_regexes { [] }
  end
end
