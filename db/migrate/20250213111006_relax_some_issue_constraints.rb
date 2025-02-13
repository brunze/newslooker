class RelaxSomeIssueConstraints < ActiveRecord::Migration[8.0]
  def change
    change_column_null :issues, :title, true
    change_column_null :issues, :published_at, true
  end
end
