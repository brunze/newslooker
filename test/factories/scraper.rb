FactoryBot.define do
  factory :scraper do
    skip_create

    links_scraper do
      LinksScraper.new(
        link_block_selector: ".link-block",
        anchor_selector: "a",
        blurb_selector: ".blurb",
        cleanup_regexes: []
      )
    end
    publication_date_scraper do
      if rand > 0.5
        NodeAttributePublicationDateScraper.new(
          node_selector: "meta[property='article:published_time']",
          node_attribute_name: "content"
        )
      else
        NodeTextPublicationDateScraper.new(
          node_selector: ".publication-date",
          extractor_regex: "(\\w+ \\d+, \\d+)\\z"
        )
      end
    end
  end
end
