# frozen_string_literal: true
module Spgateway
  class ApplicationController < ActionController::Base
    protect_from_forgery with: :null_session

    private

    def spgateway_response
      return @spgateway_response if @spgateway_response
      return nil unless params[:JSONData]
      @spgateway_response = Spgateway::Response.new(params[:JSONData])
      raise InvalidResponseError unless @spgateway_response.result.valid?
      @spgateway_response
    end

    class InvalidResponseError < StandardError
    end

    def respond_to_missing?(method)
      super || ::Rails.application.routes.url_helpers.respond_to?(method)
    end

    def method_missing(method, *args)
      if ::Rails.application.routes.url_helpers.respond_to?(method)
        ::Rails.application.routes.url_helpers.try(method, *args)
      else
        super
      end
    end
  end
end
