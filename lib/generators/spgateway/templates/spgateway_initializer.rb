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
  config.mpg_callback do |spgateway_response, controller, url_helpers|
    raise "Please configure mpg_callback in #{__FILE__}"
    # Put the trade result user facing logic here.
    #
    # Be careful not to repeat the order data updating work if you've configure
    # notify_callback to do it - because both notify_callback and mpg_callback
    # will be called when the user has done with the payment (notify_callback)
    # and then be redirected back to the website immediately (mpg_callback),
    # unexpected results might happen if you do the same thing twice at the
    # same time.
    #
    # Example implementation:
    # (this only shows the results to the user while we assume that you want
    # notify_callback - placed at the next section of this file - to do the
    # real business logic)
    #
    # if spgateway_response.status == 'SUCCESS'
    #   controller.flash[:success] = spgateway_response.message
    # else
    #   controller.flash[:error] = spgateway_response.message
    # end
    #
    # controller.redirect_to url_helpers.orders_path
  end

  # Callback triggered by Spgateway after an order has been paid.
  config.notify_callback do |spgateway_response|
    raise "Please configure notify_callback in #{__FILE__}"
    # Put the trade result proceeding logic here.
    #
    # Example implementation:
    #
    # if spgateway_response.status == 'SUCCESS'
    #   Order.find_by(serial: spgateway_response.result.merchant_order_no)
    #        .update_attributes!(paid: true)
    # else
    #   Rails.logger.info "Spgateway Payment Not Succeed: #{spgateway_response.status}: #{spgateway_response.message} (#{spgateway_response.result.to_json})"
    # end
  end
end
