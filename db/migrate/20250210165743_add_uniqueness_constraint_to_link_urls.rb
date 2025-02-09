class AddUniquenessConstraintToLinkUrls < ActiveRecord::Migration[8.0]
  def change
    add_index :links, [ :issue_id, :url ], unique: true
  end
end
