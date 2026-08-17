class ProductsController < ApplicationController
  before_action :set_product, only: %i[show]

  def index
  @pagy, @products = pagy(
    Product.active.includes(:category, featured_image_attachment: :blob).order(created_at: :desc),
    items: 12
  )
  end

  def show
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end
end
