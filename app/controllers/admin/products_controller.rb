class Admin::ProductsController < Admin::BaseController
  before_action :set_product, only: %i[show edit update destroy]

  def index
    scope = Product.includes(:category, featured_image_attachment: :blob).order(created_at: :desc)
    scope = scope.where("name LIKE ? OR sku LIKE ?", "%#{params[:q]}%", "%#{params[:q]}%") if params[:q].present?
    scope = scope.where(status: params[:status]) if params[:status].present?
    @pagy, @products = pagy(:offset, scope, limit: 20)
  end

  def show
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)

    if @product.save
      redirect_to admin_product_path(@product), notice: "Sản phẩm đã được tạo."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    @product.featured_image.purge if params.dig(:product, :remove_featured_image) == "1"

    if @product.update(product_params)
      redirect_to admin_product_path(@product), notice: "Sản phẩm đã được cập nhật."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @product.destroy
    redirect_to admin_products_path, notice: "Sản phẩm đã được xóa."
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def product_params
    params.require(:product).permit(
      :name, :description, :price, :compare_at_price,
      :inventory_count, :sku, :status, :category_id, :featured_image
    )
  end
end
