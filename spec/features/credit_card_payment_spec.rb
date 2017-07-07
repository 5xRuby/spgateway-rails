# frozen_string_literal: true
require 'integration_spec_helper'

RSpec.describe 'credit card payment', type: :feature, js: true, ngrok: true do
  before do
    NotifyCallbackTesting = double
    allow(NotifyCallbackTesting).to receive(:response) { |response| @notify_callback_response = response }
  end
  before do
    MPGCallbackTesting = double
    allow(MPGCallbackTesting).to receive(:response) { |response| @mpg_callback_response = response }
  end

  scenario 'User pays with credit card' do
    page.driver.browser.js_errors = false

    visit pages_credit_card_payment_button_path
    click_button 'Go pay'

    expect(find(:css, '#payer_mail').value).to eq('test@example.com')

    fill_in 'card_1', with: '4000'
    fill_in 'card_2', with: '2211'
    fill_in 'card_3', with: '1111'
    fill_in 'card_4', with: '1111'

    select '01', from: 'expire_m'
    select '32', from: 'expire_y'

    fill_in 'cvc', with: '111'

    check 'confirm_order'

    find(:css, '.put_send_btn .btn').click

    wait_for_ajax

    wait_for_content 'DONE', max_wait_time: 10

    expect(@notify_callback_response.status).to eq('SUCCESS')
    expect(@notify_callback_response.result.Card6No).to eq('400022')
    expect(@notify_callback_response.result.Card4No).to eq('1111')
    expect(@notify_callback_response.result.Exp).to eq('3201')

    expect(@mpg_callback_response.status).to eq('SUCCESS')
    expect(@mpg_callback_response.result.Card6No).to eq('400022')
    expect(@mpg_callback_response.result.Card4No).to eq('1111')
    expect(@mpg_callback_response.result.Exp).to eq('3201')

    expect(page).to have_content('Payment has been proceeded.')

    data = JSON.parse(find(:css, '#data').text)

    expect(data['spgateway_response']['status']).to eq('SUCCESS')
    expect(data['spgateway_response']['result']['data']['Card6No']).to eq('400022')
    expect(data['spgateway_response']['result']['data']['Card4No']).to eq('1111')
    expect(data['spgateway_response']['result']['data']['Exp']).to eq('3201')
  end
end
