Rails.application.routes.draw do
  post 'analyse', to: 'analyse#index'
  post 'store', to: 'store#index'
  get 'reports/:year/:month', to: 'reports#show'

  root to: 'home#index'
end
