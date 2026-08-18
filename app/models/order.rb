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

  STATUS_LABELS = {
    "pending"   => "Chờ xử lý",
    "paid"      => "Đã thanh toán",
    "shipped"   => "Đang vận chuyển",
    "cancelled" => "Đã hủy"
  }.freeze

  STATUS_BADGE_CLASSES = {
    "pending"   => "bg-yellow-100 text-yellow-800",
    "paid"      => "bg-blue-100 text-blue-800",
    "shipped"   => "bg-purple-100 text-purple-800",
    "cancelled" => "bg-red-100 text-red-800"
  }.freeze

  validates :full_name, :phone, :address, presence: true
  validates :status, inclusion: { in: STATUSES }
  validates :total, numericality: { greater_than_or_equal_to: 0 }

  before_update :restock_inventory_if_cancelled, if: :will_save_change_to_status?

  def can_transition_to?(new_status)
    VALID_STATUS_TRANSITIONS[status]&.include?(new_status.to_s)
  end

  def badge_class
    STATUS_BADGE_CLASSES.fetch(status, "bg-gray-100 text-gray-800")
  end

  def status_label
    STATUS_LABELS.fetch(status, status)
  end

  def self.create_from_cart!(cart, order_params, user = nil)
    Order.transaction do
      # 1. Kiểm tra tồn kho lần cuối
      cart.cart_items.each do |item|
        product = item.product.lock!

        if product.inventory_count < item.quantity
          raise ActiveRecord::Rollback,
                "Sản phẩm '#{product.name}' không đủ số lượng (còn #{product.inventory_count})"
        end
      end

      # 2. Tạo đơn hàng
      order = new(order_params)
      order.user = user
      order.total = cart.total_price
      order.status = "pending"
      order.save!

      # 3. Tạo order_items + trừ kho
      cart.cart_items.each do |item|
        order.order_items.create!(
          product: item.product,
          product_name: item.product.name,
          quantity: item.quantity,
          price: item.product.price
        )

        item.product.update!(
          inventory_count: item.product.inventory_count - item.quantity
        )
      end

      # 4. Xóa giỏ hàng
      cart.clear!

      order
    end
  end

  private

  # Khi đơn hàng chuyển sang "cancelled", hoàn lại số lượng tồn kho đã trừ lúc đặt hàng.
  # Trước đây admin có thể hủy đơn nhưng inventory_count không bao giờ được cộng lại,
  # khiến tồn kho thực tế sai lệch dần theo thời gian.
  def restock_inventory_if_cancelled
    return unless status == "cancelled"

    order_items.includes(:product).each do |item|
      item.product&.increment!(:inventory_count, item.quantity)
    end
  end
end
