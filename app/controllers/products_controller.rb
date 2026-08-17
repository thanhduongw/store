class ProductsController < ApplicationController
  before_action :set_product, only: %i[show edit update destroy]

  # GET /products
  def index
    @products = Product.includes(:category, featured_image_attachment: :blob)
                       .order(created_at: :desc)
  end

  # GET /products/1
  def show
  end

  # GET /products/new
  def new
    @product = Product.new
  end

  # POST /products
  def create
    @product = Product.new(product_params)

    if @product.save
      redirect_to @product, notice: "Sản phẩm đã được tạo thành công."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # GET /products/1/edit
  def edit
  end

  # PATCH/PUT /products/1
  def update
    if @product.update(product_params)
      redirect_to @product, notice: "Sản phẩm đã được cập nhật."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /products/1
  def destroy
    @product.destroy
    redirect_to products_path, notice: "Sản phẩm đã được xóa."
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
      :featured_image          # ← Quan trọng: phải có dòng này
    )
  end
end
