# frozen_string_literal: true
require_dependency 'spgateway/application_controller'

module Spgateway
  class NotifyCallbacksController < ApplicationController
    def proceed
      raise NotImplementedError, 'Spgateway.config.notify_callback is not a proc.' unless Spgateway.config.notify_callback.is_a? Proc
      Spgateway.config.notify_callback.call(spgateway_response, self, ::Rails.application.routes.url_helpers)
      head 200
    end
  end
end
