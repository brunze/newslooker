class CreateCrawlers < ActiveRecord::Migration[8.0]
  def change
    create_table :crawlers do |t|
      t.string :type, null: false
      t.check_constraint "type IN ('UrlTemplateCrawler', 'ArchivePageCrawler')", name: "known_crawler_type"

      t.integer :last_crawled_issue_number
      t.integer :oldest_issue_to_crawl, null: false, default: 1
      t.datetime :last_crawled_at
      t.references :newsletter, null: false, foreign_key: true, index: { unique: true }
      t.timestamps

      # UrlTemplateCrawler columns
      t.string :url_template
      t.check_constraint "type != 'UrlTemplateCrawler' OR url_template IS NOT NULL", name: "url_template_is_not_null"

      # ArchivePageCrawler columns
      t.string :archive_page_url
      t.string :issue_link_selector
      t.string :issue_number_regex
      t.check_constraint "type != 'ArchivePageCrawler' OR archive_page_url IS NOT NULL", name: "archive_page_url_is_not_null"
      t.check_constraint "type != 'ArchivePageCrawler' OR issue_link_selector IS NOT NULL", name: "issue_link_selector_is_not_null"
      t.check_constraint "type != 'ArchivePageCrawler' OR issue_number_regex IS NOT NULL", name: "issue_number_regex_is_not_null"
    end
  end
end
