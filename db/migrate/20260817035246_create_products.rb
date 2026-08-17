class CreateProducts < ActiveRecord::Migration[8.1]
  def change
    create_table :products do |t|
      t.string :name, null: false
      t.text :description
      t.decimal :price, precision: 12, scale: 2, null: false, default: 0
      t.decimal :compare_at_price, precision: 12, scale: 2
      t.integer :inventory_count, null: false, default: 0
      t.string :sku
      t.string :status, null: false, default: "draft"
      t.references :category, null: true, foreign_key: true

      t.timestamps
    end

    add_index :products, :sku, unique: true
    add_index :products, :status
  end
end
