# frozen_string_literal: true
Spgateway::Engine.routes.draw do
  post 'mpg_callbacks', to: 'mpg_callbacks#proceed'
  post 'payment_code_callbacks', to: 'payment_code_callbacks#proceed'
  post 'notify_callbacks', to: 'notify_callbacks#proceed'
end
