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

ActiveRecord::Schema[8.0].define(version: 2025_02_10_165743) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"
  enable_extension "vector"

  create_table "issues", force: :cascade do |t|
    t.bigint "newsletter_id", null: false
    t.string "url", null: false
    t.string "title", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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

  add_foreign_key "links", "issues"
end
