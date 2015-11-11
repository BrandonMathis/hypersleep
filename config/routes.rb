Rails.application.routes.draw do
  devise_for :users, :controllers => { :omniauth_callbacks => "callbacks" }

  get "/auth/:provider/callback" => 'authentications#create'
  get "/auth/failure" => "authentications#failure"

  root 'repos#index'

  resources :repos do
    collection do
      post "/:user/:name/clone", action: :clone, as: :clone
    end
  end
end
