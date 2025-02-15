FactoryBot.define do
  factory :scraper do
    skip_create

    link_block_selector { ".link-block" }
    link_selector { "a" }
    link_blurb_selector { ".blurb" }
    cleanup_regexes { [] }
    publish_date_selector { "meta[property='article:published_time']" }
    publish_date_attribute { "content" }
  end
end
