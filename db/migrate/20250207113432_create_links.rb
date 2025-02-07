class CreateLinks < ActiveRecord::Migration[8.0]
  def change
    create_table :links do |t|
      t.string :url, null: false
      t.string :text, null: false
      t.text :blurb
      t.vector :embedding, limit: EmbeddingsService::EMBEDDING_DIMENSIONS

      t.timestamps
    end
  end
end
