# Spgateway Rails Plugin [![Build Status](https://travis-ci.org/5xRuby/spgateway-rails.svg?branch=master)](https://travis-ci.org/5xRuby/spgateway-rails)

This plugin provides convenient integration with [Spgateway](https://www.spgateway.com) - an online payment service in Taiwan.


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'spgateway-rails', github: '5xRuby/spgateway-rails'
```

And then execute:

```bash
$ bundle
```

Finally, run the install generator:

```bash
$ rails generate spgateway:install
```

then set your `merchant_id`, `hash_key` and `hash_iv` in `config/initializers/spgateway.rb`.


## Basic Usage

### The simplest integration: only support immediate credit card pay off

1. Place the pay button in a view, such as:

    ```erb
    <%= spgateway_pay_button 'Go pay', payment_methods: [:credit_card], order_number: @order.serial, item_description: @order.description, amount: @order.amount, payer_email: current_user&.email, class: 'btn btn-success' %>
    ```

    > Note that we restrict the supported payment methods to only `credit_card` here.

2. Configure how to process payment results in `config/initializers/spgateway.rb`, for example:

    ```rb
      config.mpg_callback do |mpg_response, controller, url_helpers|
        if mpg_response.status == 'SUCCESS'
          Order.find_by(serial: mpg_response.result.merchant_order_no)
               .update_attributes!(paid: true)
          controller.flash[:success] = mpg_response.message
        else
          controller.flash[:error] = mpg_response.message
        end

        controller.redirect_to url_helpers.orders_path
      end
    ```

### Supporting non-real-time payment methods: using `notify_callback`

With some payment methods, such as ATM 轉帳 (VACC), 超商代碼繳費 (CVS) or 超商條碼繳費 (BARCODE), users will not complete their transaction on the web browser but maybe in front of an ATM or in a convenient store or so. Spgateway will notify our application later if such transactions has been done, and we will need an additional setup to deal with these notifications.

> Note that you will not be able to test this intergration with an local application server (i.e. `http://localhost:3000`) directly, because (in normal cases) Spgateway cannot connect to your local computer. Consider using services like [ngrok](https://ngrok.com/) to get a public URL tunneled to your local application server, and use that public URL in the browser to get things work.

1. You'll need to setup `mpg_callback` and `notify_callback` like this:

    ```rb
      # Callback after the user has been redirect back from Spgateway MPG gateway.
      config.mpg_callback do |spgateway_response, controller, url_helpers|
        # Only shows the results to the user here, while notify_callback will do the
        # actual work.

        if spgateway_response.status == 'SUCCESS'
          controller.flash[:success] = spgateway_response.message
        else
          controller.flash[:error] = spgateway_response.message
        end

        controller.redirect_to url_helpers.orders_path
      end

      # Callback triggered by Spgateway after an order has been paid.
      config.notify_callback do |spgateway_response|

        if spgateway_response.status == 'SUCCESS'
          # Find the order and mark it as paid.
          Order.find_by(serial: spgateway_response.result.merchant_order_no)
               .update_attributes!(paid: true)
        else
          # Or log the error.
          Rails.logger.info "Spgateway Payment Not Succeed: #{spgateway_response.status}: #{spgateway_response.message} (#{spgateway_response.result.to_json})"
        end
      end
    ```

    The `notify_callback` will be called when Spgateway tries to notify us about payment status updates, nomatter which payment method does the user select. So in the `mpg_callback` block, we should only write code for user-facing logic, to prevent dulipaced work and unexpected results.

2. Now you can add non-real-time payment methods to your pay button:

    ```erb
    <%= spgateway_pay_button 'Go pay', payment_methods: [:credit_card, :vacc, :cvs, :barcode], order_number: @order.serial, item_description: @order.description, amount: @order.amount, payer_email: current_user&.email, class: 'btn btn-success' %>
    ```

### Get the customer's ATM transfer account or payment code and show them on your website with `payment_code_callback`

By default, Spgateway will show the payment instruction of ATM 轉帳 (VACC), 超商代碼繳費 (CVS) or 超商條碼繳費 (BARCODE) to users on their site directly, this way you can not get the payment info and users will not be redirected back to your site.

You can add the `payment_code_callback` config to let users be redirected back to your site, so then you can have the payment info and show it to your users by yourself. Do something like this:

```rb
  config.payment_code_callback do |spgateway_response, controller, url_helpers|
    if spgateway_response.status == 'SUCCESS' &&
       spgateway_response.result.payment_type == 'VACC'

      bank_code = spgateway_response.result.bank_code
      account_number = spgateway_response.result.code_no
      expired_at =
        DateTime.parse("#{spgateway_response.result.expire_date} #{spgateway_response.result.expire_time} UTC+8")
      Order.find_by(serial: spgateway_response.result.merchant_order_no)
           .update_attributes!(bank_code: bank_code, account_number: account_number, expired_at: expired_at)
      controller.flash[:info] =
        "Please transfer the money to bank code #{bank_code}, account number #{account_number} before #{I18n.l(expired_at)}"
    else
      Rails.logger.error "Spgateway Payment Code Receive Not Succeed: #{spgateway_response.status}: #{spgateway_response.message} (#{spgateway_response.result.to_json})"
      controller.flash[:error] = "Our apologies, but an unexpected error occured, please try again"
    end

    controller.redirect_to url_helpers.orders_path
  end
```


## TODO

- Support ClientBackURL.
- Build API wrapper for QueryTradeInfo.
- Add option to double check the payment results after callback.
- Build API wrapper for CreditCard/Cancel.
- Wtite docs.
- Test, test everything!


## Contributing

Just open an issue or send a PR :)


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
