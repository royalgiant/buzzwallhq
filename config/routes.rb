require 'sidekiq/web'

Rails.application.routes.draw do
  
  devise_for :users, controllers: { sessions: 'users/sessions', passwords: 'users/passwords', registrations: 'users/registrations', omniauth_callbacks: 'users/omniauth_callbacks', confirmations: 'users/confirmations' }
  get 'auth/failure', to: 'users/omniauth_callbacks#failure'
  
  devise_scope :user do
    # authentication logic routes
    get "signup", to: "devise/registrations#new"
    post "signup", to: "devise/registrations#create"
    get "login", to: "devise/sessions#new"
    post "login", to: "devise/sessions#create"
    delete "logout", to: "devise/sessions#destroy"
    post "logout", to: "devise/sessions#destroy"
    get "logout", to: "devise/sessions#destroy"
  end
  
  root 'buzz_terms#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  resources :home, only: [:index]
  resources :buzz_terms
  resources :walls
  get 'walls/embed/:embed_token', to: 'walls#show', as: 'embed_wall'
  resources :buzzes, only: [:index, :update, :destroy]
  get 'pricing', to: 'pricing#index', as: 'pricing'

  scope controller: :static do
    get :terms
    get :privacy
  end

  namespace :purchase do
    resources :checkouts
    get "success", to: "checkouts#success"
  end

  # For sidekiq dashboard
  mount Sidekiq::Web => '/sidekiq'
  get "up" => "rails/health#show", as: :rails_health_check
end
