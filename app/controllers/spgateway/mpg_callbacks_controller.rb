# frozen_string_literal: true
require_dependency 'spgateway/application_controller'

module Spgateway
  class MPGCallbacksController < ApplicationController
    skip_before_action :verify_authenticity_token

    def proceed
      raise NotImplementedError, 'Spgateway.config.mpg_callback is not a proc.' unless Spgateway.config.mpg_callback.is_a? Proc
      instance_exec(spgateway_response, self, ::Rails.application.routes.url_helpers, &Spgateway.config.mpg_callback)
      redirect_to '/' unless performed?
    end
  end
end
