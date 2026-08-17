class Admin::DashboardController < Admin::BaseController
  def index
    @products_count = Product.count
    @orders_count = Order.count
    @pending_orders = Order.where(status: "pending").count
  end
end
