class CreateNewslettersAndIssues < ActiveRecord::Migration[8.0]
  def change
    create_table :newsletters do |t|
      t.string :name, null: false
      t.jsonb :scraper_config, null: false

      t.timestamps
    end

    create_table :issues do |t|
      t.references :newsletter, null: false
      t.string :url, null: false
      t.string :title, null: false

      t.timestamps
    end

    add_belongs_to :links, :issue, null: false, foreign_key: true
  end
end
