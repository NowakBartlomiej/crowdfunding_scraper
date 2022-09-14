class AddColums < ActiveRecord::Migration[7.0]
  def change
    add_column :collections, :external_collection_id, :integer
    add_column :collections, :title, :string
    add_column :collections, :category, :string
  end
end
