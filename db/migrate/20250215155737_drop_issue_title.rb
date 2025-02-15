class DropIssueTitle < ActiveRecord::Migration[8.0]
  def change
    remove_column :issues, :title, :string
  end
end
