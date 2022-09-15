class CreateDailySummaries < ActiveRecord::Migration[7.0]
  def change
    create_table :daily_summaries do |t|
      t.decimal :daily_sum, precision: 13, scale: 2, null: false

      t.timestamps
    end
  end
end
