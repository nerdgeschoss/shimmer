# frozen_string_literal: true

Rails.application.routes.draw do
  resources :posts
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  get "styleguide", to: "pages#styleguide"
  root "posts#index"
end
