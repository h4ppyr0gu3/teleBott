Rails.application.routes.draw do
  require 'sidekiq/web'

  mount Sidekiq::Web, at: "/sidekiq"
  Sidekiq::Web.use Rack::Auth::Basic do |username, password|
    username == "test123" && password == "test123"
  end
  root to: "bot#index"
  resources :group, only: %i[ destroy ]
  resources :bot, only: %i[ index create new update show destroy ]
  resources :message, only: %i[ edit new update destroy ]
  resources :error, only: %i[ index destroy ]

end
