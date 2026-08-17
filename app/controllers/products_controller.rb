class ProductsController < ApplicationController
  before_action :set_product, only: %i[show]

  def index
    scope = Product
      .includes(:category, featured_image_attachment: :blob)
      .active
      .order(created_at: :desc)

    @pagy, @products = pagy(
      :offset,
      scope,
      limit: 20
    )
  end

  def show
  end

  private

  def set_product
    @product = Product.active.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to products_path,
                alert: "Sản phẩm không tồn tại hoặc đã ngừng bán."
  end
end
