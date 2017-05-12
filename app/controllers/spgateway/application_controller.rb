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
  end
end
