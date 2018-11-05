Rails.application.routes.draw do
  resources :plans
  resources :secrets
  root to: "secrets#index"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
