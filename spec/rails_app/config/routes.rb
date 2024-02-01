Rails.application.routes.draw do
  resources :files, only: :show, controller: "shimmer/files"
  resources :posts

  get "styleguide", to: "pages#styleguide"
  root "posts#index"
end
