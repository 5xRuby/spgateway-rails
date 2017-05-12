# frozen_string_literal: true
module Spgateway
  class MpgCallbacksController < ApplicationController
    def proceed
      raise NotImplementedError, 'Spgateway.config.mpg_callback is not a proc.' unless Spgateway.config.mpg_callback.is_a? Proc
      Spgateway.config.mpg_callback.call(spgateway_mpg_response, self, ::Rails.application.routes.url_helpers)
      redirect_to '/' unless performed?
    end

    def spgateway_mpg_response
      return @spgateway_mpg_response if @spgateway_mpg_response
      return nil unless params[:JSONData]
      @spgateway_mpg_response = Spgateway::Response.new(params[:JSONData])
      raise InvalidResponseError unless @spgateway_mpg_response.result.valid?
      @spgateway_mpg_response
    end

    class InvalidResponseError < StandardError
    end
  end
end
