Rails.application.routes.draw do
  devise_for :users, :controllers => { :omniauth_callbacks => "callbacks" }

  get "/auth/:provider/callback" => 'authentications#create'
  get "/auth/failure" => "authentications#failure"
  get '/github/repos', to: 'github#repos'
  root 'github#repos'
end
