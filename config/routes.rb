Rails.application.routes.draw do
  resources :stories
  resources :users, only: [:new, :create, :show]
  resources :sessions, only: [:new, :create, :destroy]
end
