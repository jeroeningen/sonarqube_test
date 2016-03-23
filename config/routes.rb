Rails.application.routes.draw do
  root to: "homepages#index"

  resources :homepages, only: [:index]
  resources :sessions, only: [:new, :create, :destroy]
  resources :transactions, only: [:index]
  resources :users, only: [:create]

  get "/logout" => "sessions#destroy", as: "logout"
end
