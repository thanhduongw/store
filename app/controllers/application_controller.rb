class ApplicationController < ActionController::Base
  include Authentication
  include Pagy::Method

  helper_method :current_cart

  private

  def current_cart
    if authenticated?
      Current.user.cart || Current.user.create_cart
    else
      if session[:cart_id]
        cart = Cart.find_by(id: session[:cart_id])
        return cart if cart.present?
      end

      cart = Cart.create
      session[:cart_id] = cart.id
      cart
    end
  end
end
