# frozen_string_literal: true
require 'spgateway/sha256'

RSpec.describe Spgateway::SHA256 do
  describe '.hash' do
    it 'work as expected' do
      data = 'Amt=200&MerchantID=123456&MerchantOrderNo=20140901001&TimeStamp=1403243286&Version=1.1'
      hash_key = '1A3S21DAS3D1AS65D1'
      hash_iv = '1AS56D1AS24D'
      hash = Spgateway::SHA256.hash(data, hash_key: hash_key, hash_iv: hash_iv)

      expect(hash).to eq('841F57D750FB4B04B62DDC3ECDC26F1F4028410927DD28BD5B2E34791CC434D2')
    end
  end
end
