module Spgateway
  class Config
    include ActiveSupport::Configurable
    config_accessor :merchant_id
    config_accessor :hash_iv, :hash_key
    config_accessor :api_url, :mpg_gateway_url
    config_accessor :mpg_callback

    def mpg_callback(&block)
      if block
        config.mpg_callback = block
      else
        config.mpg_callback
      end
    end
  end
end
