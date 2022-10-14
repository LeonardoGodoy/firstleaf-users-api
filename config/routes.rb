Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  # mount Sidekiq::Web => '/sidekiq'

  namespace :v1, defaults: { format: "json" } do
    resources :users, only: %i(index create)
  end
end
