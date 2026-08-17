class AddMissingFieldsToProducts < ActiveRecord::Migration[8.1]
  def change
    add_column :products, :compare_at_price, :decimal, precision: 12, scale: 2
    add_column :products, :sku, :string
    add_column :products, :status, :string, default: "draft", null: false

    add_index :products, :sku, unique: true
    add_index :products, :status
  end
end
