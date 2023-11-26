Rails.application.routes.draw do
  get 'checkout/new'
  # Devise routes for Admin and Customers
  devise_for :admin_users, ActiveAdmin::Devise.config
  devise_for :customers

  # Active Admin routes
  ActiveAdmin.routes(self)

  # Product routes
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

  # Checkout routes
  get '/checkout', to: 'orders#new', as: 'checkout'
  # get '/checkout', to: 'checkout#new', as: 'new_checkout'
  # post '/checkout', to: 'checkout#create', as: 'create_checkout'
  get '/initiate_checkout', to: 'carts#initiate_checkout', as: 'initiate_checkout'

  # Define routes for Orders
  resources :orders, only: [:new, :create]

  # Resourceful routes for customers with additional collection route
  resources :customers do
    collection do
      get 'alphabetized'
    end
  end

  # Set the root to the products index page
  root 'products#index'
end