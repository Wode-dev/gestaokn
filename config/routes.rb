Rails.application.routes.draw do
  resources :plans
  root to: "secrets#index"
  resources :secrets
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
