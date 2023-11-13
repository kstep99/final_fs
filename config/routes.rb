Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :customers

  # Define a route for the dashboard controller's index action
  get 'dashboard/index', as: :dashboard_index

  # This sets the root to the products index page
  root 'products#index'

  # Routes for products
  resources :products, only: [:index, :show] # Add other actions as needed

  # Resourceful routes for customers
  resources :customers do
    collection do
      get 'alphabetized' # This adds the /customers/alphabetized path
    end
  end
end
