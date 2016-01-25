require 'sidekiq/web'

Rails.application.routes.draw do
  devise_for :users, :controllers => { :omniauth_callbacks => "callbacks" }
  mount Sidekiq::Web => '/sidekiq'

  get "/auth/:provider/callback" => 'authentications#create'
  get "/auth/failure" => "authentications#failure"

  root 'repos#index'

  resources :repos do
    collection do
      post "/:owner/:name/suspend", action: :suspend, as: :suspend
    end

    member do
      get '/download', action: :download, as: :download
    end
  end
end
