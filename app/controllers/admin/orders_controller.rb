class Admin::OrdersController < Admin::BaseController
  before_action :set_order, only: %i[show update]

  def index
    scope = Order.includes(:user).order(created_at: :desc)
    scope = scope.where(status: params[:status]) if params[:status].present?
    @orders = scope
  end

  def show
    @order_items = @order.order_items.includes(product: { featured_image_attachment: :blob })
  end

  def update
    new_status = params[:order][:status]

    unless @order.can_transition_to?(new_status)
      redirect_to admin_order_path(@order), alert: "Không thể chuyển từ '#{@order.status}' sang '#{new_status}'."
      return
    end

    if @order.update(status: new_status)
      redirect_to admin_order_path(@order), notice: "Cập nhật trạng thái đơn hàng thành công."
    else
      redirect_to admin_order_path(@order), alert: "Không thể cập nhật."
    end
  end

  private

  def set_order
    @order = Order.find(params[:id])
  end
end
