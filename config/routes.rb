# config/routes.rb

Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :customers

  # This sets the customers index as the homepage for your app
  root 'customers#index'

  # Resourceful routes for customers
  resources :customers do
    collection do
      get 'alphabetized' # This adds the /customers/alphabetized path
    end
  end
end
