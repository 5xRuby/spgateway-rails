# frozen_string_literal: true
require 'spec_helper'
require 'spgateway/mpg_form'

RSpec.describe Spgateway::MPGForm do
  describe 'initialize' do
    it 'raise an error if the parameter is not a Hash' do
      expect { Spgateway::MPGForm.new('hi') }.to raise_error(ArgumentError, /must pass a hash/)
    end

    it 'raise an error if required parameter is missing' do
      expect { Spgateway::MPGForm.new(MerchantID: 'abc', MerchantOrderNo: 1, ItemDesc: 2) }.to raise_error(ArgumentError, /'Amt' is missing/)
    end
  end

  describe '#*' do
    it 'sets or gets the attrs' do
      form = Spgateway::MPGForm.new(MerchantID: 'abc', MerchantOrderNo: 1, ItemDesc: 2, Amt: 123)
      form.Abc = 1
      expect(form.Abc).to eq(1)
    end
  end

  describe '#set_attr' do
    it 'sets the attr for the form' do
      form = Spgateway::MPGForm.new(MerchantID: 'abc', MerchantOrderNo: 1, ItemDesc: 2, Amt: 123)
      form.set_attr('Abc', 1)
      expect(form.Abc).to eq(1)
    end
  end
end
