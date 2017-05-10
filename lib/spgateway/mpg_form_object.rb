module Spgateway
  class MPGFormObject
    REQUIRED_PARAMS = %w(Version MerchantID MerchantOrderNo ItemDesc Amt TimeStamp RespondType).freeze

    def initialize(params)
      unless params.is_a? Hash
        raise ArgumentError, "When initializing #{self.class.name}, you must pass a hash as an argument."
      end

      @params = {}
      missing_params = REQUIRED_PARAMS.map(&:clone)

      params.each_pair do |k, v|
        key = k.to_s
        value = v.to_s
        missing_params.delete(key)
        @params[key] = value
      end

      if @params['Version'].nil?
        @params['Version'] = '1.2'
        missing_params.delete('Version')
      end

      if @params['MerchantID'].nil?
        @params['MerchantID'] = Spgateway.config.merchant_id
        missing_params.delete('MerchantID')
      end

      if @params['TimeStamp'].nil?
        @params['TimeStamp'] = Time.now.to_i
        missing_params.delete('TimeStamp')
      end

      if @params['RespondType'].nil?
        @params['RespondType'] = 'JSON'
        missing_params.delete('RespondType')
      end

      return self if missing_params.count.zero?
      raise ArgumentError, "The required params: #{missing_params.map { |s| "'#{s}'" }.join(', ')} #{missing_params.count > 1 ? 'are' : 'is'} missing."
    end

    def sorted_params
      @params.sort
    end

    def to_s
      sorted_params.map { |k, v| "#{k}=#{v}" }.join('&')
    end

    def check_value
      data = "Amt=#{@params['Amt']}&MerchantID=#{@params['MerchantID']}&MerchantOrderNo=#{@params['MerchantOrderNo']}&TimeStamp=#{@params['TimeStamp']}&Version=#{@params['Version']}"
      Spgateway::SHA256.hash(data)
    end

    alias CheckValue check_value

    private

    def method_missing(method_name)
      if @params.key?(method_name.to_s)
        @params[method_name.to_s]
      else
        super
      end
    end

    def respond_to_missing?(method_name, _include_private = false)
      @params.key?(method_name.to_s)
    end
  end
end
