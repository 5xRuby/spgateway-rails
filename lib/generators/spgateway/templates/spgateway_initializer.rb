# frozen_string_literal: true
Spgateway.configure do |config|
  # Spgateway merchant ID.
  # You can get your ID on https://www.spgateway.com/shop/member_shop/shop_list
  # (or https://cwww.spgateway.com/shop/member_shop/shop_list for development).
  config.merchant_id = 'place_your_merchant_id_here'

  # The HashKey and HashIV of the merchant on Spgateway. This can be found in
  # the「銷售中心 › 商店管理 › 商店資料設定，詳細資料 › API 串接金鑰」section of the
  # Spgateway member centre.
  config.hash_key = 'place_your_hash_key_here'
  config.hash_iv = 'place_your_hash_iv_here'

  # Spgateway API URL.
  # Normally will be 'https://ccore.spgateway.com/API' for development and
  # 'https://core.spgateway.com/API' for production.
  config.api_url = 'https://ccore.spgateway.com/API'

  # MPG gateway URL (i.e. the "action" attribute in user's purchasing form).
  # Normally this will be 'https://ccore.spgateway.com/MPG/mpg_gateway' for
  # development and 'https://core.spgateway.com/MPG/mpg_gateway' for
  # production.
  config.mpg_gateway_url = 'https://ccore.spgateway.com/MPG/mpg_gateway'

  # Callback after the user has been redirect back from Spgateway MPG gateway.
  config.mpg_callback do |_mpg_response, _controller, _url_helpers|
    raise "Please configure mpg_callback in #{__FILE__}"
    # Put the trade result proceeding logic here.
    #
    # Example implementation:
    #
    # if mpg_response.status == 'SUCCESS'
    #   Order.find_by(serial: mpg_response.result.merchant_order_no)
    #        .update_attributes(paid: true)
    #   controller.flash[:success] = mpg_response.message
    # else
    #   controller.flash[:error] = mpg_response.message
    # end
    #
    # controller.redirect_to url_helpers.orders_path
  end
end
