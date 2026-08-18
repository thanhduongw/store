class CheckoutsController < ApplicationController
  allow_unauthenticated_access

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
      build_order_params,
      authenticated? ? Current.user : nil
    )

    session[:guest_order_id] = @order.id unless authenticated?

    recipient = @order.user&.email_address || @order.email
    UserMailer.order_confirmation(@order).deliver_later if recipient.present?

    redirect_to order_path(@order), notice: "Đặt hàng thành công! Cảm ơn bạn."
  rescue StandardError => e
    @order = Order.new(build_order_params)
    flash.now[:alert] = e.message.presence || "Có lỗi xảy ra khi đặt hàng. Vui lòng thử lại."
    render :new, status: :unprocessable_entity
  end

  private

  def build_order_params
    raw = params.require(:order).permit(:full_name, :phone, :email, :note)
    province = params[:province].to_s.strip
    district = params[:district].to_s.strip
    ward     = params[:ward].to_s.strip
    specific = params[:specific_address].to_s.strip

    parts = [ specific, ward, district, province ].reject(&:blank?)
    raw.merge(address: parts.join(", "))
  end
end
