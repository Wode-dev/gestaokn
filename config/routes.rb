Rails.application.routes.draw do
  get 'main/home'
  get "sync", to: "sync#sync_partial"

  get "sync/selective", to: "sync#selective_sync"
  post "sync/tosystem", to: "sync#update_system_selective", as: :update_system
  post "sync/tomikrotik", to:"sync#update_mikrotik_selective", as: :update_mikrotik

  get "plans/check", to:"plans#check"

  
  resources :plans

  resources :secrets
  post "secrets/pay", to: "secrets#payment", as: :payment
  post "secrets/switch", to:"secrets#switch_secret"
  post "secrets/installation", to: "secrets#add_instalation_detail", as: :installation_details

  root to: "main#home"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
