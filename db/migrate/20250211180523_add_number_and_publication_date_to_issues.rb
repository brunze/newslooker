class AddNumberAndPublicationDateToIssues < ActiveRecord::Migration[8.0]
  def change
    add_column :issues, :number, :integer, null: false
    add_column :issues, :published_at, :datetime, null: false

    add_index :issues, [ :newsletter_id, :number ], unique: true
    add_index :issues, [ :newsletter_id, :url ], unique: true
  end
end
