Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks" }

  resources :projects do
    resources :builds, only: %i(show create destroy) do
      get ":partial", to: "builds#show", on: :member, as: "build_detail_content"
    end
  end

  resources :saturn_installations do
    resources :project_integrations, only: %i(new create)
  end

  resources :rebuilds, only: :create
  root "projects#index"

  namespace :api do
    namespace :v1 do
      resources :jobs, only: [] do
        resources :system_logs, only: :create
        resources :test_reports, only: :create
        resource :test_output, only: :create
        resources :job_events, only: :create
        resources :test_suite_finished_events, only: :create
        resource :job_machine, only: :destroy
      end

      resources :github_events
      resources :github_tokens, only: :create
      resources :job_machine_images, only: :update
    end
  end
end
