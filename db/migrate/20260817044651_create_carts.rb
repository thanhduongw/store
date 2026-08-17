class CreateCarts < ActiveRecord::Migration[8.1]
  def change
    create_table :carts do |t|
      t.references :user, null: true, foreign_key: true   # null: true vì khách chưa đăng nhập cũng có giỏ

      t.timestamps
    end
  end
end
