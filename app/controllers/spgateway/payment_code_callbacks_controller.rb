# frozen_string_literal: true
require_dependency 'spgateway/application_controller'

module Spgateway
  class PaymentCodeCallbacksController < ApplicationController
    def proceed
      raise NotImplementedError, 'Spgateway.config.payment_code_callback is not a proc.' unless Spgateway.config.payment_code_callback.is_a? Proc
      Spgateway.config.payment_code_callback.call(spgateway_response, self, ::Rails.application.routes.url_helpers)
      redirect_to '/' unless performed?
    end
  end
end
