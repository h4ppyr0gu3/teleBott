Rails.application.routes.draw do
  require 'sidekiq/web'

  mount Sidekiq::Web, at: "/sidekiq"
  Sidekiq::Web.use Rack::Auth::Basic do |username, password|
    username == "test123" && password == "test123"
  end
  root to: "bot#index"
  resources :group
  resources :bot
  resources :message
  resources :error

end
