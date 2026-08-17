class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_one :cart, dependent: :destroy
  has_many :orders, dependent: :nullify

  # Chuẩn hóa email (xóa khoảng trắng + viết thường)
  normalizes :email_address, with: ->(e) { e.strip.downcase }

  # Validation
  validates :first_name, :last_name, presence: true
  validates :email_address, presence: true, uniqueness: true

  # Method tiện lợi
  def full_name
    "#{first_name} #{last_name}".strip
  end

  def admin?
    admin
  end
end
