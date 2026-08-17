class SessionsController < ApplicationController
  allow_unauthenticated_access only: %i[ new create ]
  rate_limit to: 10, within: 3.minutes, only: :create,
             with: -> { redirect_to new_session_path, alert: "Try again later." }

  def new
  end

  def create
    if user = User.authenticate_by(params.permit(:email_address, :password))
      merge_guest_cart_to_user(user)
      start_new_session_for user
      redirect_to after_authentication_url, notice: "Đăng nhập thành công!"
    else
      redirect_to new_session_path, alert: "Email hoặc mật khẩu không đúng."
    end
  end

  def destroy                         # Sửa: chuyển ra khỏi private
    terminate_session
    redirect_to root_path, notice: "Bạn đã đăng xuất thành công.", status: :see_other
  end

  private

  def merge_guest_cart_to_user(user)
    return unless session[:cart_id]

    guest_cart = Cart.find_by(id: session[:cart_id])
    return unless guest_cart&.cart_items&.any?

    user_cart = user.cart || user.create_cart

    guest_cart.cart_items.each do |item|
      user_cart.add_product(item.product, item.quantity)
    end

    guest_cart.destroy
    session.delete(:cart_id)
  end
end
