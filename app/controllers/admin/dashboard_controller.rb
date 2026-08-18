class Admin::DashboardController < Admin::BaseController
  def index
    @products_count   = Product.count
    @active_products  = Product.active.count
    @orders_count     = Order.count
    @pending_orders   = Order.where(status: "pending").count
    @categories_count = Category.count
    @total_revenue    = Order.where(status: %w[paid shipped]).sum(:total)
    @recent_orders    = Order.includes(:user).order(created_at: :desc).limit(8)
  end
end
