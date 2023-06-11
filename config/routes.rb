Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :github_tokens, only: :create

      resources :builds, only: :create do
        resources :build_events, only: :create
      end
    end
  end

  resources :projects
  resources :builds, only: %i(show create)
  root "projects#index"
end
