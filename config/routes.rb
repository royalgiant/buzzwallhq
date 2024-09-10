Rails.application.routes.draw do
  root 'home#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  resources :home, only: [:index]

  scope controller: :static do
    get :terms
    get :privacy
  end

  namespace :purchase do
    resources :checkouts
    get "success", to: "checkouts#success"
  end
end
