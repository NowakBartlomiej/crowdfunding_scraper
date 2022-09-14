class AddIndex < ActiveRecord::Migration[7.0]
  def change
    add_index :collections, :external_collection_id, unique: true
  end
end
