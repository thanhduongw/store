class CartItemsController < ApplicationController
  def create
    product = Product.find(params[:product_id])
    quantity = [ params[:quantity].to_i, 1 ].max

    if product.inventory_count < quantity
      redirect_to product_path(product), alert: "Số lượng vượt quá tồn kho (còn #{product.inventory_count})."
      return
    end

    current_item = current_cart.cart_items.find_by(product: product)
    new_quantity = current_item ? current_item.quantity + quantity : quantity

    if product.inventory_count < new_quantity
      redirect_to product_path(product), alert: "Số lượng vượt quá tồn kho (còn #{product.inventory_count})."
      return
    end

    current_cart.add_product(product, quantity)
    redirect_to cart_path, notice: "Đã thêm sản phẩm vào giỏ hàng."
  end

  def update
    @cart_item = current_cart.cart_items.find(params[:id])
    quantity = params[:quantity].to_i

    if quantity < 1
      @cart_item.destroy
      redirect_to cart_path, notice: "Đã xóa sản phẩm khỏi giỏ hàng."
      return
    end

    if @cart_item.product.inventory_count < quantity
      redirect_to cart_path, alert: "Số lượng vượt quá tồn kho (còn #{@cart_item.product.inventory_count})."
      return
    end

    if @cart_item.update(quantity: quantity)
      redirect_to cart_path, notice: "Đã cập nhật số lượng."
    else
      redirect_to cart_path, alert: "Không thể cập nhật."
    end
  end

  def destroy
    @cart_item = current_cart.cart_items.find(params[:id])
    @cart_item.destroy
    redirect_to cart_path, notice: "Đã xóa sản phẩm khỏi giỏ hàng."
  end
end
