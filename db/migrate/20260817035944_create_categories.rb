class CreateCategories < ActiveRecord::Migration[8.1]
  def change
    create_table :categories do |t|
      t.string :name, null: false          # bắt buộc phải có tên
      t.text :description

      t.timestamps
    end

    add_index :categories, :name, unique: true   # tên danh mục không trùng
  end
end
