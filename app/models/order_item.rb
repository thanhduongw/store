class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :product, optional: true

  def total_price
    price * quantity
  end
end
