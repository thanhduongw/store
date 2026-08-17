class Order < ApplicationRecord
  belongs_to :user, optional: true
  has_many :order_items, dependent: :destroy

  STATUSES = %w[pending paid shipped cancelled].freeze

  VALID_STATUS_TRANSITIONS = {
    "pending"   => %w[paid cancelled],
    "paid"      => %w[shipped cancelled],
    "shipped"   => %w[cancelled],
    "cancelled" => []
  }.freeze

  validates :full_name, :phone, :address, presence: true
  validates :status, inclusion: { in: STATUSES }
  validates :total, numericality: { greater_than_or_equal_to: 0 }

  def can_transition_to?(new_status)
    VALID_STATUS_TRANSITIONS[status]&.include?(new_status.to_s)
  end

  def self.create_from_cart!(cart, order_params, user = nil)
    transaction do
      cart.cart_items.each do |item|
        product = item.product.lock!
        if product.inventory_count < item.quantity
          raise StandardError,
                "Sản phẩm '#{product.name}' không đủ số lượng (còn #{product.inventory_count})"
        end
      end

      order = new(order_params)
      order.user  = user
      order.total = cart.total_price
      order.status = "pending"
      order.save!

      cart.cart_items.each do |item|
        order.order_items.create!(
          product: item.product,
          product_name: item.product.name,
          quantity: item.quantity,
          price: item.product.price
        )
        item.product.update!(inventory_count: item.product.inventory_count - item.quantity)
      end

      cart.clear!
      order
    end
  end
end
