class Order < ApplicationRecord
  belongs_to :user, optional: true
  has_many :order_items, dependent: :destroy

  STATUSES = %w[pending paid shipped cancelled].freeze

  validates :full_name, :phone, :address, presence: true
  validates :status, inclusion: { in: STATUSES }
  validates :total, numericality: { greater_than_or_equal_to: 0 }

  # Tạo đơn hàng từ giỏ hàng
  def self.create_from_cart(cart, order_params)
    order = new(order_params)
    order.total = cart.total_price
    order.status = "pending"

    cart.cart_items.each do |item|
      order.order_items.build(
        product: item.product,
        product_name: item.product.name,
        quantity: item.quantity,
        price: item.product.price
      )
    end

    order
  end
end
