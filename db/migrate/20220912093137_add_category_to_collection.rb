class AddCategoryToCollection < ActiveRecord::Migration[7.0]
  def change
    add_column :collections, :category, :string
  end
end
