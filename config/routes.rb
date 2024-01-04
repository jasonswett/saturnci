Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks" }

  namespace :api do
    namespace :v1 do
      resources :builds, only: [] do
        resources :build_events, only: :create
        resources :build_reports, only: :create
        resources :build_logs, only: :create
        resource :build_machine, only: :destroy
      end

      resources :github_events
      resources :github_tokens, only: :create
    end
  end

  resources :projects
  resources :project_integrations, only: %i(new create)
  resources :builds, only: %i(show create)
  resources :rebuilds, only: :create
  root "projects#index"
end
