class ApplicationController < ActionController::Base
  include Authentication
  include Pagy::Method
  # Cho phép dùng current_cart ở cả Controller và View
  helper_method :current_cart

  private

  def current_cart
    if authenticated?
      # Người dùng đã đăng nhập
      Current.user.cart || Current.user.create_cart
    else
      # Khách chưa đăng nhập → dùng session
      if session[:cart_id]
        cart = Cart.find_by(id: session[:cart_id])
        return cart if cart.present?
      end

      # Tạo giỏ hàng mới cho khách
      cart = Cart.create
      session[:cart_id] = cart.id
      cart
    end
  end
end
