class OrdersController < ApplicationController
  allow_unauthenticated_access only: [ :show ]
  before_action :set_order, only: [ :show ]

  def index
    @status_filter = params[:status].presence
    scope = Current.user.orders.includes(order_items: :product)
    scope = scope.where(status: @status_filter) if @status_filter.present?
    @orders = scope.order(created_at: :desc)
  end

  def show
  end

  def cancel
    @order = Current.user.orders.find(params[:id])

    unless @order.can_transition_to?("cancelled")
      redirect_to orders_path, alert: "Không thể hủy đơn hàng này."
      return
    end

    @order.update!(status: "cancelled")
    redirect_to orders_path, notice: "Đơn hàng ##{@order.id} đã được hủy thành công."
  rescue ActiveRecord::RecordNotFound
    redirect_to orders_path, alert: "Không tìm thấy đơn hàng."
  end

  private

  def set_order
    @order = if authenticated? && Current.user.admin?
               Order.find_by(id: params[:id])
    elsif authenticated?
               Current.user.orders.find_by(id: params[:id])
    else
               guest_order_id = session[:guest_order_id]
               Order.find_by(id: params[:id]) if guest_order_id == params[:id].to_i
    end

    redirect_to root_path, alert: "Không tìm thấy đơn hàng." unless @order
  end
end
