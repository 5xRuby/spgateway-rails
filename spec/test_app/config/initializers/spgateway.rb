# frozen_string_literal: true
Spgateway.configure do |config|
  config.merchant_id = 'MS11591073'
  config.hash_key = '7KZsaNdslfbViAsPIz2gaEw4CjIHwdXE'
  config.hash_iv = 'XX67KkA6zM2SmuH4'

  config.api_url = 'https://ccore.spgateway.com/API'
  config.mpg_gateway_url = 'https://ccore.spgateway.com/MPG/mpg_gateway'

  config.mpg_callback do |spgateway_response|
    # Pass the response into a mocked module so we can inspect it in the test
    MPGCallbackTesting.response(spgateway_response)

    flash[:notice] = "Payment has been proceeded."

    redirect_to pages_done_path(
      data: {
        spgateway_response: spgateway_response
      }.to_json
    )
  end

  config.notify_callback do |spgateway_response|
    # Pass the response into a mocked module so we can inspect it in the test
    NotifyCallbackTesting.response(spgateway_response)
  end
end
