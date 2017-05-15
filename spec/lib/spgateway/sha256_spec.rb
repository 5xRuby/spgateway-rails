# frozen_string_literal: true
require 'spec_helper'
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

    it 'work as expected with hash_iv_first: true' do
      data = 'Amt=100&MerchantID=1422967&MerchantOrderNo=840f022&TradeNo=14061313541640927'
      hash_key = 'abcdefg'
      hash_iv = '1234567'
      hash = Spgateway::SHA256.hash(data, hash_key: hash_key, hash_iv: hash_iv, hash_iv_first: true)

      expect(hash).to eq('62C687AF6409E46E79769FAF54F54FE7E75AAE50BAF0767752A5C337670B8EDB')
    end
  end
end
