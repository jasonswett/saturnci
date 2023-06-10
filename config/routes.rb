Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :builds, only: :create
    end
  end

  resources :projects
  root "projects#index"
end
