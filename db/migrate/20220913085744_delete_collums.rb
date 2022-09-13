class DeleteCollums < ActiveRecord::Migration[7.0]
  def change
    remove_column :collections, :donator
    remove_column :collections, :percentage

  end
end
