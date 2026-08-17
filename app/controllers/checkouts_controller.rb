class CheckoutsController < ApplicationController
  def new
    @cart = current_cart

    if @cart.cart_items.empty?
      redirect_to cart_path, alert: "Giỏ hàng của bạn đang trống."
      return
    end

    @order = Order.new

    # Nếu đã đăng nhập thì tự điền thông tin
    if authenticated?
      @order.full_name = Current.user.full_name
    end
  end

  def create
    @cart = current_cart
    @order = Order.create_from_cart(@cart, order_params)

    if authenticated?
      @order.user = Current.user
    end

    if @order.save
      @cart.clear!   # Xóa giỏ hàng sau khi đặt thành công
      redirect_to order_path(@order), notice: "Đặt hàng thành công! Cảm ơn bạn."
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def order_params
    params.require(:order).permit(:full_name, :phone, :address, :note)
  end
end
