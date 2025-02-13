class CreateCrawlers < ActiveRecord::Migration[8.0]
  def change
    add_column :newsletters, :crawler, :jsonb
    add_column :newsletters, :oldest_issue_to_crawl, :integer, null: false, default: 1
    add_column :newsletters, :last_crawled_at, :datetime
  end
end
