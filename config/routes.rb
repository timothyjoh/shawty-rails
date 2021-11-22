# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :links
    end
  end

  get '/edit/:id', to: 'home#edit', as: :editable
  get '/:slug', to: 'home#short', as: :short
  get '/', to: 'home#index', as: :home
end
