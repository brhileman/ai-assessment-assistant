Rails.application.routes.draw do
  # Stakeholder assessment routes (token-based)
  get '/assessment/:token', to: 'assessment#show', as: :assessment
  post '/assessment/:token/start', to: 'assessment#start', as: :start_assessment
  get '/assessment/:token/completed', to: 'assessment#assessment_already_completed', as: :assessment_completed
  
  # Voice assessment interface routes (token-based)
  get '/voice/:token', to: 'voice_assessment#show', as: :voice_assessment
  patch '/voice/:token/complete', to: 'voice_assessment#complete', as: :complete_voice_assessment
  
  # Voice conversation API routes
  namespace :api do
    post 'voice/:token/start', to: 'voice_conversation#start_session', as: 'start_voice_session'
    get 'voice/:token/realtime_config', to: 'voice_conversation#get_realtime_config', as: 'voice_realtime_config'
    post 'voice/:token/transcript', to: 'voice_conversation#update_transcript', as: 'update_voice_transcript'
    post 'voice/:token/audio', to: 'voice_conversation#process_audio', as: 'process_voice_audio'
    post 'voice/:token/message', to: 'voice_conversation#send_text_message', as: 'send_voice_message'
    post 'voice/:token/end', to: 'voice_conversation#end_session', as: 'end_voice_session'
    get 'voice/:token/status', to: 'voice_conversation#session_status', as: 'voice_session_status'
  end
  
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
    resources :companies do
      resources :stakeholders, only: [:new, :create, :destroy], param: :token do
        member do
          post :resend_invitation
        end
      end
    end
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
