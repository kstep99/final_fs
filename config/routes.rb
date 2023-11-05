Rails.application.routes.draw do
  get 'customers/index'
  get 'customers/show'
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :customers
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

   # This sets the customers index as the homepage for your app
   root 'customers#index'

   # Resourceful routes for customers, which includes routes for index, show, new, edit, create, update, and destroy actions
   resources :customers
end
