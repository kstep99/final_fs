# config/routes.rb

Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :customers

  # Define a route for the dashboard controller's index action
  # You only need this line once, and it should have a unique name.
  get 'dashboard/index', as: :dashboard_index

  # This sets the customers index as the homepage for your app
  root 'customers#index'

  # Resourceful routes for customers
  resources :customers do
    collection do
      get 'alphabetized' # This adds the /customers/alphabetized path
    end
  end
end
