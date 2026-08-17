class CheckoutsController < ApplicationController
  def new
    @cart = current_cart

    if @cart.cart_items.empty?
      redirect_to cart_path, alert: "Giỏ hàng của bạn đang trống."
      return
    end

    @order = Order.new
    @order.full_name = Current.user.full_name.presence if authenticated?
  end

  def create
    @cart = current_cart

    if @cart.cart_items.empty?
      redirect_to cart_path, alert: "Giỏ hàng của bạn đang trống."
      return
    end

    @order = Order.create_from_cart!(
      @cart,
      order_params,
      authenticated? ? Current.user : nil
    )

    redirect_to order_path(@order), notice: "Đặt hàng thành công! Cảm ơn bạn."
  rescue StandardError => e
    @order = Order.new(order_params)
    flash.now[:alert] = e.message.presence || "Có lỗi xảy ra khi đặt hàng. Vui lòng thử lại."
    render :new, status: :unprocessable_entity
  end

  private

  def order_params
    params.require(:order).permit(:full_name, :phone, :address, :note)
  end
end
