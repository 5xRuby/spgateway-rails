# frozen_string_literal: true
module Spgateway
  class Config
    include ActiveSupport::Configurable
    config_accessor :merchant_id
    config_accessor :hash_iv, :hash_key
    config_accessor :api_url, :mpg_gateway_url
    config_accessor :mpg_callback, :notify_callback, :payment_code_callback

    def mpg_callback(&block)
      if block
        config.mpg_callback = block
      else
        config.mpg_callback
      end
    end

    def notify_callback(&block)
      if block
        config.notify_callback = block
      else
        config.notify_callback
      end
    end

    def payment_code_callback(&block)
      if block
        config.payment_code_callback = block
      else
        config.payment_code_callback
      end
    end
  end
end
