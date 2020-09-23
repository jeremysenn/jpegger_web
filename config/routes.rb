Rails.application.routes.draw do
  resources :suspect_lists
  namespace :admin do
      resources :image_files
      resources :users
      resources :companies

      root to: "image_files#index"
    end
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
  resources :shipment_files
  
  resources :images do
    member do
      get 'show_jpeg_image'
      get 'show_preview_image'
      get 'send_pdf_data'
    end
  end
  
  resources :shipments do
    member do
      get 'show_jpeg_image'
      get 'show_preview_image'
      get 'send_pdf_data'
    end
  end
  
  resources :cust_pics do
    member do
      get 'show_jpeg_image'
      get 'show_preview_image'
      get 'send_pdf_data'
    end
  end
  
  resources :companies
  resources :searches
  resources :signatures
  resources :cameras do
    member do
      get 'capture_image'
    end
  end
  
  resources :suspect_lists
  
end
