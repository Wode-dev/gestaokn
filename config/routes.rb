Rails.application.routes.draw do
  
  devise_scope :user do
    put 'administracao/save', to: 'users/registrations#save_users', as: :save_users_administration
    post 'administracao/save', to: 'users/registrations#save_users'
  end

  devise_for :users, controllers:{
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    passwords: 'users/passwords'
  }
  get 'forms', to: "payment_forms#index", as: :payment_forms
  put 'forms', to:"payment_forms#update"
  delete 'forms', to:"payment_forms#destroy"
  post 'forms', to: "payment_forms#create"

  get 'inicio', to:"main#initial_configuration", as: :initial_configuration
  get 'administracao', to:"main#users_administration", as: :users_administration
  
  get 'edit/payment/:id', to: "edit_financial#edit_payment", as: :edit_payment
  post 'edit/payment/:id', to:"edit_financial#confirm_payment", as: :confirm_payment_edition
  delete 'edit/payment/:id', to: "edit_financial#destroy_payment", as: :destroy_payment
  
  get 'edit/bill/:id', to: "edit_financial#edit_bill", as: :edit_bill
  post 'edit/bill/:id', to:"edit_financial#confirm_bill", as: :confirm_bill_edition
  delete 'edit/bill/:id', to: "edit_financial#destroy_bill", as: :destroy_bill
  
  get 'edit/install/:id', to: "edit_financial#edit_install", as: :edit_install
  post 'edit/install/:id', to:"edit_financial#confirm_install", as: :confirm_install_edition
  delete 'edit/install/:id', to: "edit_financial#destroy_bill", as: :destroy_install

  resources :records
  get "instalacoes/confirmar/:id", to: "records#confirm", as: :confirm_client
  post "instalacoes/confirmar", to: "records#set_secret_and_instalation", as: :set_record

  get 'main/home'
  get "sync", to: "sync#sync_new"
  get "bring_new", to:"sync#sync_bring_new", as: :sync_bring_new

  get "sync/selective", to: "sync#selective_sync"
  post "sync/tosystem", to: "sync#update_system_selective", as: :update_system
  post "sync/tomikrotik", to:"sync#update_mikrotik_selective", as: :update_mikrotik

  get "plans/check", to:"plans#check"

  resources :plans

  get "configuracoes", to:"main#settings", as: :settings
  post "configuracoes", to: "main#save_settings", as: :save_settings
  post "configuracoes/teste", to: "main#test_mikrotik_connection", as: :test_mikrotik_connection

  post "secrets/schedule_stop", to: "secrets#schedule_block", as: :schedule_block
  post "secrets/unschedule_stop", to: "secrets#unschedule_block", as: :unschedule_block
  resources :secrets

  post "secrets/pay", to: "secrets#payment", as: :payment
  post "secrets/bill", to: "secrets#bill", as: :bill
  post "secrets/switch", to:"secrets#switch_secret"
  post "secrets/installation", to: "secrets#add_instalation_detail", as: :installation_details
  post "secrets/note", to: "secrets#commit_note", as: :commit_note
  get "secrets/note/:id", to: "secrets#edit_note", as: :edit_note

  root to: "main#home"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
