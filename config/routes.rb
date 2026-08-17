Rails.application.routes.draw do
  root "products#index"

  resource :session
  resources :passwords, param: :token
  resource :sign_up, only: %i[show create]

  resources :products, only: [ :index, :show ]
  resources :categories, only: [ :index, :show ]

  resource :cart, only: [ :show ]
  resources :cart_items, only: [ :create, :update, :destroy ]

  resource :checkout, only: [ :new, :create ]
  resources :orders, only: [ :show ]

  namespace :admin do
    root to: "dashboard#index"
    resources :products
    resources :orders, only: [ :index, :show, :update ]
  end
end
