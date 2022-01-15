# frozen_string_literal: true

Rails.application.routes.draw do
  scope defaults: { format: 'json' } do
    resources :users, only: [] do
      collection do
        post :signup
        post :login
      end
    end

    resources :events, only: %i(index show)

    resources :tickets, only: %i(index) do
      collection do
        post :buy
      end
    end
  end
end
