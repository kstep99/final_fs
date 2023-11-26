Rails.application.routes.draw do
  # Devise routes for Admin and Customers
  devise_for :admin_users, ActiveAdmin::Devise.config
  devise_for :customers
  get '/checkout', to: 'checkout#new', as: 'checkout'

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
  # Update the route for cart item quantity update
  patch '/cart/update/:product_id', to: 'carts#update_cart_item', as: 'update_cart_item'

  # Resourceful routes for customers with additional collection route
  resources :customers do
    collection do
      get 'alphabetized'
    end
  end

  # Set the root to the products index page
  root 'products#index'
end
