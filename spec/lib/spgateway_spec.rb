# frozen_string_literal: true
require 'spec_helper'
require 'spgateway/version'

RSpec.describe Spgateway do
  describe '::VERSION' do
    it 'is a string' do
      expect(Spgateway::VERSION).to be_a_kind_of(String)
    end
  end
end
