class Admin::ProductsController < Admin::BaseController
  before_action :set_product, only: %i[show edit update destroy]

  def index
    scope = Product
      .includes(:category, images_attachments: :blob)
      .order(created_at: :desc)

    if params[:q].present?
      query = "%#{params[:q]}%"

      scope = scope.where(
        "name LIKE ? OR sku LIKE ?",
        query,
        query
      )
    end

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
      redirect_to admin_product_path(@product),
                  notice: "Sản phẩm đã được tạo."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    # Xóa các ảnh được chọn
    if params[:product][:remove_image_ids].present?
      params[:product][:remove_image_ids].each do |id|
        @product.images.find_by(id: id)&.purge
      end
    end

    if @product.update(product_params.except(:remove_image_ids))
      redirect_to admin_product_path(@product),
                  notice: "Sản phẩm đã được cập nhật."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @product.destroy

    redirect_to admin_products_path,
                notice: "Sản phẩm đã được xóa."
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def product_params
    params.require(:product).permit(
      :name,
      :description,
      :price,
      :compare_at_price,
      :inventory_count,
      :sku,
      :status,
      :category_id,
      images: [],
      remove_image_ids: []
    )
  end
end
