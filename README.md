# spgateway-rails

An API wrapper for [Spgateway](https://www.spgateway.com).


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'spgateway-rails'
```

And then execute:

```bash
$ bundle
```

Finally, run the install generator:

```bash
$ rails generate spgateway:install
```


## Basic Usage

1. Place the pay button in a view, for example:

```erb
<%= spgateway_pay_button 'Go pay', order_number: @order.serial, item_description: @order.description, amount: @order.amount %>
```

2. Configure how to process payment results in `config/initializers/spgateway.rb`, such as:


```rb
  config.mpg_callback do |mpg_response, controller, url_helpers|
    if mpg_response.status == 'SUCCESS'
      Order.find_by(serial: mpg_response.result.merchant_order_no)
           .update_attributes(paid: true)
      controller.flash[:success] = mpg_response.message
    else
      controller.flash[:error] = mpg_response.message
    end

    controller.redirect_to url_helpers.orders_path
  end
```

## TODO

- Build API wrapper for QueryTradeInfo.
- Add option to double check the payment results after callback.
- Add webhook endpoint to deal with async payment results.
- Build API wrapper for CreditCard/Cancel.


## Contributing

Contribution directions go here.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
