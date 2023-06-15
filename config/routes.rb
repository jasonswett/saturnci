Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :builds, only: :create do
        resources :build_events, only: :create
        resources :build_reports, only: :create
      end

      resources :github_events
      resources :github_tokens, only: :create
    end
  end

  resources :projects
  resources :builds, only: %i(show create)
  root "projects#index"
end
