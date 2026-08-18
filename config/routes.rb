Rails.application.routes.draw do
  # Trang chủ
  root "products#index"

  # Authentication
  resource :session
  resources :passwords, param: :token
  resource :sign_up, only: %i[show create]

  # Sản phẩm & Danh mục (khách chỉ được xem, không có quyền tạo/sửa/xóa)
  resources :products, only: [ :index, :show ]
  resources :categories, only: [ :index, :show ]

  # Giỏ hàng
  resource :cart, only: [ :show ]
  resources :cart_items, only: [ :create, :update, :destroy ]

  # Tài khoản
  resource :profile, only: [ :show, :edit, :update ]

  # Thanh toán & Đơn hàng
  resource :checkout, only: [ :new, :create ]
  resources :orders, only: [ :index, :show ] do
    member do
      patch :cancel
    end
  end

  # ======================
  # ADMIN
  # ======================
  namespace :admin do
    root to: "dashboard#index"

    resources :products
    resources :categories
    resources :orders, only: [ :index, :show, :update ]
  end
end
