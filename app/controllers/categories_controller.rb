class CategoriesController < ApplicationController
  allow_unauthenticated_access

  def index
    @categories = Category.left_joins(:products)
                          .select("categories.*, COUNT(CASE WHEN products.status = 'active' THEN 1 END) AS products_count")
                          .group("categories.id")
                          .order(:name)
  end

  def show
    @category = Category.find(params[:id])

    scope = @category.products
                     .includes(images_attachments: :blob)
                     .active

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

    @pagy, @products = pagy(:offset, scope, limit: 20)
  rescue ActiveRecord::RecordNotFound
    redirect_to categories_path, alert: "Không tìm thấy danh mục."
  end
end
