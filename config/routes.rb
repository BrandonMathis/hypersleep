Rails.application.routes.draw do
  devise_for :users, :controllers => { :omniauth_callbacks => "callbacks" }

  get "/auth/:provider/callback" => 'authentications#create'
  get "/auth/failure" => "authentications#failure"

  root 'repos#index'

  resources :repos do
    collection do
      post "/:owner/:name/suspend", action: :suspend, as: :suspend
    end
  end
end
