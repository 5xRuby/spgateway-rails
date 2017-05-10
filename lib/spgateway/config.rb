module Spgateway
  class Config
    include ActiveSupport::Configurable
    config_accessor :merchant_id
    config_accessor :hash_iv, :hash_key
    config_accessor :api_url, :mpg_gateway_url
  end
end
