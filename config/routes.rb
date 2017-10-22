# frozen_string_literal: true

require 'resque/server'
Rails.application.routes.draw do
  root 'welcome#index'

  resources :packages, only: %i[index show]

  mount Resque::Server, at: '/jobs'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
