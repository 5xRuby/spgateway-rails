Rails.application.routes.draw do
  mount Spgateway::Rails::Engine => "/spgateway-rails"
end
