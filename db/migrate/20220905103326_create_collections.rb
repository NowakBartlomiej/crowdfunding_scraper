class CreateCollections < ActiveRecord::Migration[7.0]
  def change
    create_table :collections do |t|
      t.integer :their_id
      t.string :slug
      t.decimal :amount, precision: 13, scale: 2
      t.integer :donator
      t.decimal :percentage, precision: 13, scale: 2

      t.timestamps
    end
  end
end
