# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api do
    resources :games do
      resources :rolls
      resources :frames do
        resources :rolls
      end
    end
  end
end
