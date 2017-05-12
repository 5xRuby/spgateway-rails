# frozen_string_literal: true
Spgateway::Engine.routes.draw do
  post 'mpg_callbacks', to: 'mpg_callbacks#proceed'
end
