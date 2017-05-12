# frozen_string_literal: true
module Spgateway
  class MPGForm
    REQUIRED_ATTRS = %w(Version MerchantID MerchantOrderNo ItemDesc Amt TimeStamp RespondType).freeze

    def initialize(attrs)
      unless attrs.is_a? Hash
        raise ArgumentError, "When initializing #{self.class.name}, you must pass a hash as an argument."
      end

      @attrs = {}
      missing_attrs = REQUIRED_ATTRS.map(&:clone)

      attrs.each_pair do |k, v|
        key = k.to_s
        value = v.to_s
        missing_attrs.delete(key)
        @attrs[key] = value
      end

      if @attrs['Version'].nil?
        @attrs['Version'] = '1.2'
        missing_attrs.delete('Version')
      end

      if @attrs['MerchantID'].nil?
        @attrs['MerchantID'] = Spgateway.config.merchant_id
        missing_attrs.delete('MerchantID')
      end

      if @attrs['TimeStamp'].nil?
        @attrs['TimeStamp'] = Time.now.to_i
        missing_attrs.delete('TimeStamp')
      end

      if @attrs['RespondType'].nil?
        @attrs['RespondType'] = 'JSON'
        missing_attrs.delete('RespondType')
      end

      return self if missing_attrs.count.zero?
      raise ArgumentError, "The required attrs: #{missing_attrs.map { |s| "'#{s}'" }.join(', ')} #{missing_attrs.count > 1 ? 'are' : 'is'} missing."
    end

    def set_attr(name, value)
      @attrs[name] = value
    end

    def return_url
      @attrs['ReturnURL']
    end

    def return_url=(url)
      @attrs['ReturnURL'] = url
    end

    def notify_url
      @attrs['NotifyURL']
    end

    def notify_url=(url)
      @attrs['NotifyURL'] = url
    end

    def sorted_attrs
      @attrs.sort
    end

    def to_s
      sorted_attrs.map { |k, v| "#{k}=#{v}" }.join('&')
    end

    def check_value
      data = "Amt=#{@attrs['Amt']}&MerchantID=#{@attrs['MerchantID']}&MerchantOrderNo=#{@attrs['MerchantOrderNo']}&TimeStamp=#{@attrs['TimeStamp']}&Version=#{@attrs['Version']}"
      Spgateway::SHA256.hash(data)
    end

    alias CheckValue check_value

    private

    def method_missing(method_name)
      if @attrs.key?(method_name.to_s)
        @attrs[method_name.to_s]
      else
        super
      end
    end

    def respond_to_missing?(method_name, _include_private = false)
      @attrs.key?(method_name.to_s)
    end
  end
end
