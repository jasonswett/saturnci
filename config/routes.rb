Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get 'github_tokens/create'
      resources :builds, only: :create
      resources :github_tokens, only: :create
    end
  end

  resources :projects
  root "projects#index"
end
