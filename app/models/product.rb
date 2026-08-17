class Product < ApplicationRecord
  belongs_to :category, optional: true

  # Active Storage - ảnh sản phẩm
  has_one_attached :featured_image
  has_many :cart_items, dependent: :destroy

  # Các trạng thái hợp lệ
  STATUSES = %w[draft active].freeze

  # Validation
  validates :name, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }
  validates :compare_at_price, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :inventory_count, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :status, inclusion: { in: STATUSES }
  validates :sku, uniqueness: true, allow_blank: true

  # Scope tiện lợi
  scope :active, -> { where(status: "active") }
  scope :in_stock, -> { where("inventory_count > 0") }

  def on_sale?
    compare_at_price.present? && compare_at_price > price
  end

  def discount_percentage
    return 0 unless on_sale?
    (((compare_at_price - price) / compare_at_price) * 100).round
  end
end
