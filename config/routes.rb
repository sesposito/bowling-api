# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api do
    resources :games, only: %i[index show create destroy] do
      resources :throws, only: %i[create]
      resources :frames, only: %i[index show] do
        resources :throws, only: %i[index show create]
      end
    end
  end
end
