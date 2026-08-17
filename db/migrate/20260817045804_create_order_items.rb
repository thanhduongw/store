class CreateOrderItems < ActiveRecord::Migration[8.1]
  def change
    create_table :order_items do |t|
      t.references :order, null: false, foreign_key: true
      t.references :product, null: true, foreign_key: true  # null: true phòng trường hợp sản phẩm bị xóa sau này
      t.integer :quantity, null: false
      t.decimal :price, precision: 12, scale: 2, null: false  # Giá tại thời điểm mua
      t.string :product_name, null: false                   # Lưu tên sản phẩm để không bị mất

      t.timestamps
    end
  end
end
