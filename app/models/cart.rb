class Cart < ApplicationRecord
  belongs_to :user, optional: true
  has_many :cart_items, dependent: :destroy
  has_many :products, through: :cart_items

  # Tính tổng tiền của giỏ hàng
  def total_price
    cart_items.sum { |item| item.total_price }
  end

  # Tổng số lượng sản phẩm trong giỏ
  def total_quantity
    cart_items.sum(:quantity)
  end

  # Thêm sản phẩm vào giỏ (nếu đã có thì tăng số lượng)
  def add_product(product, quantity = 1)
    quantity = quantity.to_i
    return false if quantity < 1
    return false if product.inventory_count < 1

    current_item = cart_items.find_by(product: product)

    if current_item
      new_qty = current_item.quantity + quantity
      return false if product.inventory_count < new_qty
      current_item.update!(quantity: new_qty)
    else
      return false if product.inventory_count < quantity
      cart_items.create!(product: product, quantity: quantity)
    end
    true
  end
  def clear!
    cart_items.destroy_all
  end
end
