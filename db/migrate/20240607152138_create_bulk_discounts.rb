class CreateBulkDiscounts < ActiveRecord::Migration[7.1]
  def change
    create_table :bulk_discounts do |t|
      t.integer :quantity_threshold
      t.decimal :percentage_discount, precision: 5, scale: 2, null: false # allows for a decimal with precision of 5 and scale of 2. Allows for potential discount max of 99.99%
      t.references :merchant, null: false, foreign_key: true

      t.timestamps
    end
  end
end
