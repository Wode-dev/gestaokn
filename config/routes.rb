Rails.application.routes.draw do
  
  get 'edit/payment/:id'
  get 'edit/bill/:id'
  get 'edit/install/:id'

  resources :records
  get "instalacoes/confirmar/:id", to: "records#confirm", as: :confirm_client
  post "instalacoes/confirmar", to: "records#set_secret_and_instalation", as: :set_record

  get 'main/home'
  get "sync", to: "sync#sync_partial"

  get "sync/selective", to: "sync#selective_sync"
  post "sync/tosystem", to: "sync#update_system_selective", as: :update_system
  post "sync/tomikrotik", to:"sync#update_mikrotik_selective", as: :update_mikrotik

  get "plans/check", to:"plans#check"

  resources :plans

  get "configuracoes", to:"main#settings", as: :settings
  post "configuracoes", to: "main#save_settings", as: :save_settings
  post "configuracoes/teste", to: "main#test_mikrotik_connection", as: :test_mikrotik_connection

  resources :secrets
  post "secrets/pay", to: "secrets#payment", as: :payment
  post "secrets/switch", to:"secrets#switch_secret"
  post "secrets/installation", to: "secrets#add_instalation_detail", as: :installation_details
  post "secrets/note", to: "secrets#commit_note", as: :commit_note
  get "secrets/note/:id", to: "secrets#edit_note", as: :edit_note

  root to: "main#home"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
