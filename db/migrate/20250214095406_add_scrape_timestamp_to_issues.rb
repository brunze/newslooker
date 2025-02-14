class AddScrapeTimestampToIssues < ActiveRecord::Migration[8.0]
  def change
    add_column :issues, :last_scraped_at, :datetime
  end
end
