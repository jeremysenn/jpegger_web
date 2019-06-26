Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get 'welcome/dashboard'
  root 'welcome#dashboard'
  
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'
  
  resources :users_admin, :controller => 'users'
#  resources :users_admin, :controller => 'users' do
#    collection do
#      get 'forgot_password'
#    end
#    member do
#      get 'confirm'
#    end
#  end

  resources :image_files
  resources :images
  resources :companies
  
end
