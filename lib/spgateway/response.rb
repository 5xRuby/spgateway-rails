module Spgateway
  class Response
    attr_reader :status
    attr_reader :message
    attr_reader :result

    def initialize(params)
      @status = params['Status']
      @status = params['Message']

      result = params['Result']

      result = JSON.parse(result) if result.is_a? String

      @result = Result.new(result)
    end

    class Result
      def initialize(params)
        @data = params
      end

      def valid?
        check_value == expected_check_value
      end

      def expected_check_value
        data = "Amt=#{amt}&MerchantID=#{merchant_id}&MerchantOrderNo=#{merchant_order_no}&TimeStamp=#{time_stamp}&Version=#{version}"
        Spgateway::SHA256.hash(data)
      end

      private

      def method_missing(method_name)
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
        [key.to_s, key.to_s.classify, key.to_s.classify.gsub(/Id/, 'ID')]
      end
    end
  end
end
