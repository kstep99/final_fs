Rails.application.routes.draw do
  # Devise routes for Admin and Customers
  devise_for :admin_users, ActiveAdmin::Devise.config
  devise_for :customers

  # Active Admin routes
  ActiveAdmin.routes(self)

  # Set the root to the products index page
  root 'products#index'

  # Product routes with nested cart management routes
  resources :products, only: [:index, :show] do
    member do
      post 'add_to_cart', to: 'products#add_to_cart'
    end
  end

  # Profile routes for a singular resource
  resource :profile, only: [:show, :edit, :update]

  # Cart routes
  get '/cart', to: 'carts#show', as: 'cart'
  delete '/cart/remove/:product_id', to: 'carts#remove_from_cart', as: 'remove_from_cart'
  patch '/cart/update/:product_id', to: 'carts#update_cart_item', as: 'update_cart_item'

  # Routes for orders, including the new order form
  resources :orders, only: [:new, :create]

  # Custom route for initiating checkout
  get '/initiate_checkout', to: 'carts#initiate_checkout', as: 'initiate_checkout'

  # Route for calculating taxes
  get '/calculate_taxes/:province_id', to: 'orders#calculate_taxes', as: 'calculate_taxes'

  # For webhooks with stripe
  post 'webhooks/stripe', to: 'webhooks#stripe'

  # Route for the PaymentsController create action
  post 'payments', to: 'payments#create', as: 'payments'

  # If you have success and cancel actions
  get 'payments/success', to: 'payments#success', as: 'payments_success'
  get 'payments/cancel', to: 'payments#cancel', as: 'payments_cancel'

  get '/users/:id', to: 'users#show', as: 'user_profile'

  # config/routes.rb
get 'lidar', to: 'lidars#show'


  # Resourceful routes for customers with an additional collection route
  resources :customers do
    collection do
      get 'alphabetized'
    end
  end
end