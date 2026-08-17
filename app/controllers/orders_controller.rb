class OrdersController < ApplicationController
  before_action :require_authentication
  before_action :set_order, only: [ :show ]

  def show
  end

  private

  def set_order
    @order = if Current.user.admin?
               Order.find(params[:id])
    else
               Current.user.orders.find(params[:id])
    end
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, alert: "Không tìm thấy đơn hàng."
  end
end
