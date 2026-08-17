class CreateOrders < ActiveRecord::Migration[8.1]
  def change
    create_table :orders do |t|
      t.references :user, null: true, foreign_key: true   # null: true để hỗ trợ khách chưa đăng nhập
      t.string :status, null: false, default: "pending"
      t.decimal :total, precision: 12, scale: 2, null: false, default: 0

      # Thông tin giao hàng
      t.string :full_name, null: false
      t.string :phone, null: false
      t.text :address, null: false
      t.text :note

      t.timestamps
    end

    add_index :orders, :status
  end
end
