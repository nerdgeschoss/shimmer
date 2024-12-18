# frozen_string_literal: true

Rails.application.routes.draw do
  resources :files, only: :show, controller: "shimmer/files"
  resources :posts do
    collection do
      get :modal
    end

    get :other, on: :collection
  end

  get "styleguide", to: "pages#styleguide"
  root "posts#index"
end
