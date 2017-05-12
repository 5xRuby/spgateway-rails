# frozen_string_literal: true
require_dependency 'spgateway/application_controller'

module Spgateway
  class MPGCallbacksController < ApplicationController
    def proceed
      raise NotImplementedError, 'Spgateway.config.mpg_callback is not a proc.' unless Spgateway.config.mpg_callback.is_a? Proc
      Spgateway.config.mpg_callback.call(spgateway_response, self, ::Rails.application.routes.url_helpers)
      redirect_to '/' unless performed?
    end
  end
end
