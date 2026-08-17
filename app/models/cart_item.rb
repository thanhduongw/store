class CartItem < ApplicationRecord
  belongs_to :cart
  belongs_to :product

  validates :quantity, numericality: { only_integer: true, greater_than: 0 }

  def total_price
    return 0 unless product
    (product.price || 0) * quantity
  end
end
