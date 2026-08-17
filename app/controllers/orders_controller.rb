class OrdersController < ApplicationController
  before_action :set_order, only: [ :show ]

  def show
  end

  private

  def set_order
    @order = Order.find(params[:id])
  end
end
