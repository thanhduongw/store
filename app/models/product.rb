class Product < ApplicationRecord
  belongs_to :category, optional: true

  has_one_attached :featured_image
  has_many :cart_items, dependent: :destroy
  has_many :order_items, dependent: :nullify   # Thêm để tính "Đã bán"

  STATUSES = %w[draft active].freeze

  validates :name, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }
  validates :compare_at_price, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :inventory_count, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :status, inclusion: { in: STATUSES }
  validates :sku, uniqueness: true, allow_blank: true

  validate :acceptable_image

  scope :active, -> { where(status: "active") }
  scope :in_stock, -> { where("inventory_count > 0") }

  def on_sale?
    compare_at_price.present? && compare_at_price > price
  end

  def discount_percentage
    return 0 unless on_sale? && compare_at_price.to_f > 0
    (((compare_at_price - price) / compare_at_price) * 100).round
  end

  def sold_count
    order_items.sum(:quantity)
  end

  private

  def acceptable_image
    return unless featured_image.attached?

    unless featured_image.blob.content_type.in?(%w[image/jpeg image/png image/webp image/jpg])
      errors.add(:featured_image, "chỉ chấp nhận ảnh JPEG, PNG hoặc WEBP")
    end

    if featured_image.blob.byte_size > 5.megabytes
      errors.add(:featured_image, "kích thước không được vượt quá 5MB")
    end
  end
end
