class CreateCollections < ActiveRecord::Migration[7.0]
  def change
    create_table :collections do |t|
      t.integer :their_Id
      t.string :slug
      t.decimal :amount
      t.integer :person
      t.decimal :percentage

      t.timestamps
    end
  end
end
