
require 'sidekiq-cron'
require 'sidekiq/web'
require 'sidekiq/cron/web'

Rails.application.routes.draw do
  namespace :admin do
    resources :users
    root to: "users#index"
  end
  root to: 'visitors#index'
  devise_for :users
  resources :users

	mount Sidekiq::Web, at: '/sidekiq'
end
