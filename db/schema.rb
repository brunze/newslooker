# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_02_12_160841) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"
  enable_extension "vector"

  create_table "crawlers", force: :cascade do |t|
    t.string "type", null: false
    t.integer "last_crawled_issue_number"
    t.integer "oldest_issue_to_crawl", default: 1, null: false
    t.datetime "last_crawled_at"
    t.bigint "newsletter_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "url_template"
    t.string "archive_page_url"
    t.string "issue_link_selector"
    t.string "issue_number_regex"
    t.index ["newsletter_id"], name: "index_crawlers_on_newsletter_id", unique: true
    t.check_constraint "type::text <> 'ArchivePageCrawler'::text OR archive_page_url IS NOT NULL", name: "archive_page_url_is_not_null"
    t.check_constraint "type::text <> 'ArchivePageCrawler'::text OR issue_link_selector IS NOT NULL", name: "issue_link_selector_is_not_null"
    t.check_constraint "type::text <> 'ArchivePageCrawler'::text OR issue_number_regex IS NOT NULL", name: "issue_number_regex_is_not_null"
    t.check_constraint "type::text <> 'UrlTemplateCrawler'::text OR url_template IS NOT NULL", name: "url_template_is_not_null"
    t.check_constraint "type::text = ANY (ARRAY['UrlTemplateCrawler'::character varying, 'ArchivePageCrawler'::character varying]::text[])", name: "known_crawler_type"
  end

  create_table "issues", force: :cascade do |t|
    t.bigint "newsletter_id", null: false
    t.string "url", null: false
    t.string "title", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "number", null: false
    t.datetime "published_at", null: false
    t.index ["newsletter_id", "number"], name: "index_issues_on_newsletter_id_and_number", unique: true
    t.index ["newsletter_id", "url"], name: "index_issues_on_newsletter_id_and_url", unique: true
    t.index ["newsletter_id"], name: "index_issues_on_newsletter_id"
  end

  create_table "links", force: :cascade do |t|
    t.string "url", null: false
    t.string "text", null: false
    t.text "blurb"
    t.vector "embedding", limit: 1024
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "issue_id", null: false
    t.index ["issue_id", "url"], name: "index_links_on_issue_id_and_url", unique: true
    t.index ["issue_id"], name: "index_links_on_issue_id"
  end

  create_table "newsletters", force: :cascade do |t|
    t.string "name", null: false
    t.jsonb "scraper_config", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "crawlers", "newsletters"
  add_foreign_key "links", "issues"
end
