class RenameScraperColumn < ActiveRecord::Migration[8.0]
  def change
    rename_column :newsletters, :scraper_config, :scraper
  end
end
