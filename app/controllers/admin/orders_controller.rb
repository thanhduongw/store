class Admin::OrdersController < Admin::BaseController
  before_action :set_order, only: %i[show update]

  def index
    @orders = Order.includes(:user).order(created_at: :desc)
  end

  def show
  end

  def update
    if @order.update(order_params)
      redirect_to admin_order_path(@order), notice: "Cập nhật trạng thái đơn hàng thành công."
    else
      redirect_to admin_order_path(@order), alert: "Không thể cập nhật."
    end
  end

  private

  def set_order
    @order = Order.find(params[:id])
  end

  def order_params
    params.require(:order).permit(:status)
  end
end
