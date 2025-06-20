Rails.application.routes.draw do
  # Admin authentication with magic links  
  devise_for :admins, controllers: {
    magic_links: 'admins/magic_links'
  }
  
  # Custom magic link routes for our flow
  scope :admins do
    get 'magic_link/new', to: 'admins/magic_links#new', as: 'new_admin_magic_link'
    post 'magic_link', to: 'admins/magic_links#create', as: 'admin_magic_links'
    get 'magic_link/sent', to: 'admins/magic_links#show', as: 'admin_magic_link_sent'
  end
  
  # Magic link authentication route (used in emails)
  get '/admin_magic_link_auth', to: 'admins/magic_links#verify', as: 'admin_magic_link_auth'
  
  # Admin routes
  namespace :admin do
    root 'dashboard#index'
  end
  
  # Welcome page routes
  root "pages#welcome"
  get "pages/welcome"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
