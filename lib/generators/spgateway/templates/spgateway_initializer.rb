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
end
