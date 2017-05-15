Rails.application.routes.draw do
  mount Spgateway::Engine => '/spgateway'

  get 'pages/credit_card_payment_button', to: 'pages#credit_card_payment_button'
  get 'pages/done', to: 'pages#done'
end
