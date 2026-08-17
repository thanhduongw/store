Rails.application.routes.draw do
  # Trang chủ
  root "products#index"

  # Authentication
  resource :session
  resources :passwords, param: :token
  resource :sign_up, only: %i[show create]

  # Sản phẩm & Danh mục
  resources :products
  resources :categories, only: [ :index, :show ]

  # Giỏ hàng
  resource :cart, only: [ :show ]
  resources :cart_items, only: [ :create, :update, :destroy ]

  # Thanh toán & Đơn hàng
  resource :checkout, only: [ :new, :create ]
  resources :orders, only: [ :show ]

  # ======================
  # ADMIN
  # ======================
  namespace :admin do
    root to: "dashboard#index"

    resources :products
    resources :orders, only: [ :index, :show, :update ]
  end
end
