Rails.application.routes.draw do
  get "plans/check", to:"plans#check"
  resources :plans

  resources :secrets
  root to: "secrets#index"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
