Rails.application.routes.draw do
  get 'main/home'
  get "sync", to: "sync#sync_partial"

  get "plans/check", to:"plans#check"
  resources :plans

  resources :secrets
  post "secrets/pay", to: "secrets#payment"
  root to: "main#home"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
