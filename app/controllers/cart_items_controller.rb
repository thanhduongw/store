class CartItemsController < ApplicationController
  def create
    product = Product.find(params[:product_id])
    quantity = params[:quantity].to_i
    quantity = 1 if quantity < 1

    current_cart.add_product(product, quantity)

    redirect_to cart_path, notice: "Đã thêm sản phẩm vào giỏ hàng."
  end

  def update
    @cart_item = current_cart.cart_items.find(params[:id])

    if @cart_item.update(quantity: params[:quantity])
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
