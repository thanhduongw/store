class ProductsController < ApplicationController
  allow_unauthenticated_access
  before_action :set_product, only: %i[show]

  def index
    scope = Product
      .includes(:category, images_attachments: :blob)
      .active

    if params[:q].present?
      query = "%#{params[:q]}%"
      scope = scope.where("name LIKE ? OR description LIKE ?", query, query)
    end

    scope = scope.where(category_id: params[:category_id]) if params[:category_id].present?
    scope = scope.where("price >= ?", params[:min_price].to_f) if params[:min_price].present?
    scope = scope.where("price <= ?", params[:max_price].to_f) if params[:max_price].present?

    scope = case params[:sort]
    when "price_asc"  then scope.order(price: :asc)
    when "price_desc" then scope.order(price: :desc)
    when "most_sold"
      scope.order(Arel.sql(
        "(SELECT COALESCE(SUM(oi.quantity), 0) FROM order_items oi WHERE oi.product_id = products.id) DESC"
      ))
    else
      scope.order(created_at: :desc)
    end

    @categories = Category.order(:name)
    @pagy, @products = pagy(:offset, scope, limit: 20)
  end

  def show
  end

  private

  def set_product
    @product = Product
      .includes(:category, images_attachments: :blob)
      .active
      .find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to products_path, alert: "Không tìm thấy sản phẩm."
  end
end
