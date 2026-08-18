class Product < ApplicationRecord
  belongs_to :category, optional: true

  has_many_attached :images
  has_many :cart_items, dependent: :destroy
  has_many :order_items, dependent: :nullify

  STATUSES = %w[draft active].freeze

  validates :name, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }
  validates :compare_at_price, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :inventory_count, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :status, inclusion: { in: STATUSES }
  validates :sku, uniqueness: true, allow_blank: true

  validate :acceptable_images

  scope :active, -> { where(status: "active") }
  scope :in_stock, -> { where("inventory_count > 0") }

  # Backward compatible
  def featured_image
    images.first
  end

  def featured_image_attached?
    images.attached?
  end

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

  def acceptable_images
    return unless images.attached?

    images.each do |image|
      unless image.blob.content_type.in?(%w[image/jpeg image/png image/webp image/jpg])
        errors.add(:images, "chỉ chấp nhận ảnh JPEG, PNG hoặc WEBP")
        break
      end

      if image.blob.byte_size > 5.megabytes
        errors.add(:images, "mỗi ảnh không được vượt quá 5MB")
        break
      end
    end
  end
end
