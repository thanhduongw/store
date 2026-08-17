class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_one :cart, dependent: :destroy
  has_many :orders, dependent: :nullify

  normalizes :email_address, with: ->(e) { e.strip.downcase }
  normalizes :first_name, :last_name, with: ->(name) { name.strip }

  validates :first_name, :last_name, presence: true, length: { maximum: 50 }
  validates :email_address,
            presence: true,
            uniqueness: true,
            format: { with: URI::MailTo::EMAIL_REGEXP, message: "không đúng định dạng" }

  validates :password,
            length: { minimum: 8, message: "phải có ít nhất 8 ký tự" },
            if: -> { password.present? }

  def full_name
    "#{first_name} #{last_name}".strip
  end

  def admin?
    admin == true
  end
end
