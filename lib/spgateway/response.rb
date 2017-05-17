# frozen_string_literal: true
require 'spgateway/attr_key_helper'

module Spgateway
  class Response
    attr_reader :status
    attr_reader :message
    attr_reader :result

    def initialize(data)
      data = JSON.parse(data) if data.is_a? String

      @status = data['Status']
      @message = data['Message']

      result = data['Result']

      result = JSON.parse(result) if result.is_a? String

      @result = Result.new(result)
    end

    class Result
      include AttrKeyHelper

      def initialize(data)
        @data = data
      end

      def valid?
        try(:check_value) == expected_check_value ||
          try(:check_code) == expected_check_code
      end

      def expected_check_value
        data = "Amt=#{@data['Amt']}&MerchantID=#{@data['MerchantID']}&MerchantOrderNo=#{@data['MerchantOrderNo']}&TimeStamp=#{@data['TimeStamp']}&Version=#{@data['Version']}"
        Spgateway::SHA256.hash(data)
      end

      def expected_check_code
        data = "Amt=#{@data['Amt']}&MerchantID=#{@data['MerchantID']}&MerchantOrderNo=#{@data['MerchantOrderNo']}&TradeNo=#{@data['TradeNo']}"
        Spgateway::SHA256.hash(data, hash_iv_first: true)
      end

      private

      def method_missing(method_name, *args)
        data_key = data_key_for(method_name)
        if data_key
          @data[data_key]
        else
          super
        end
      end

      def respond_to_missing?(method_name, _include_private = false)
        !data_key_for(method_name).nil?
      end

      def data_key_for(name)
        possible_data_keys_for(name).find { |k| @data.key?(k) }
      end

      def possible_data_keys_for(key)
        [key.to_s, convert_to_attr_key(key)]
      end
    end
  end
end
