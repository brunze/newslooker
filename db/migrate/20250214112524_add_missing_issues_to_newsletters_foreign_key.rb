class AddMissingIssuesToNewslettersForeignKey < ActiveRecord::Migration[8.0]
  def change
    add_foreign_key :issues, :newsletters
  end
end
