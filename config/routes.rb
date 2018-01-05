Rails.application.routes.draw do
  namespace :units, defaults: { format: :json } do
    resources :si, only: [:index]
  end
end
