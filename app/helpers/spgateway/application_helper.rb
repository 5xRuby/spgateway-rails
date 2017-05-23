# frozen_string_literal: true
module Spgateway
  module ApplicationHelper
    def spgateway_mpg_form_for(
      mpg_form_object,
      submit: 'Go',
      submit_class: '',
      mpg_gateway_url: Spgateway.config.mpg_gateway_url
    )
      unless mpg_form_object.is_a? Spgateway::MPGForm
        raise ArgumentError, "The first argument for 'pay2goo_form_for' must be a Spgateway::MPGForm."
      end

      form_tag(mpg_gateway_url, method: :post) do
        mpg_form_object.sorted_attrs.each do |param_pair|
          name, value = param_pair
          concat hidden_field_tag name, value
        end

        concat hidden_field_tag :CheckValue, mpg_form_object.check_value

        concat submit_tag submit, class: submit_class
      end
    end

    def spgateway_pay_button(title, options)
      raise ArgumentError, 'Missing required argument: order_number.' unless options[:order_number]
      raise ArgumentError, 'Missing required argument: item_description.' unless options[:item_description]
      raise ArgumentError, 'Missing required argument: amount.' unless options[:amount]

      form_attributes = options.except(
        :order_number,
        :item_description,
        :amount,
        :payer_email,
        :payment_methods,
        :class,
        :mpg_gateway_url
      )

      form_attributes[:MerchantOrderNo] = options[:order_number]
      form_attributes[:ItemDesc] = options[:item_description]
      form_attributes[:Amt] = options[:amount]
      form_attributes[:Email] = options[:payer_email]

      form = Spgateway::MPGForm.new(form_attributes)

      form.return_url =
        Spgateway::Engine.routes.url_helpers.mpg_callbacks_url(host: request.host, port: request.port)

      if [80, 443].include?(request.port) && Spgateway.config.payment_code_callback
        form.customer_url =
          Spgateway::Engine.routes.url_helpers.payment_code_callbacks_url(host: request.host, port: request.port)
      end

      if [80, 443].include?(request.port) && Spgateway.config.notify_callback
        form.notify_url =
          Spgateway::Engine.routes.url_helpers.notify_callbacks_url(host: request.host, port: request.port)
      end

      if options[:payment_methods].is_a? Array
        options[:payment_methods].each do |payment_method|
          case payment_method.to_sym
          when :credit
            form.set_attr 'CREDIT', '1'
          when :credit_card
            form.set_attr 'CREDIT', '1'
          when :inst_flag
            form.set_attr 'InstFlag', '1'
          when :installment
            form.set_attr 'InstFlag', '1'
          when :credit_red
            form.set_attr 'CreditRed', '1'
          when :unionpay
            form.set_attr 'UNIONPAY', '1'
          when :webatm
            form.set_attr 'WEBATM', '1'
          when :vacc
            form.set_attr 'VACC', '1'
          when :cvs
            form.set_attr 'CVS', '1'
          when :barcode
            form.set_attr 'BARCODE', '1'
          else
            form.set_attr payment_method, '1'
          end
        end
      end

      spgateway_mpg_form_for(
        form,
        submit: title,
        submit_class: options[:class],
        mpg_gateway_url: options[:mpg_gateway_url] || Spgateway.config.mpg_gateway_url
      )
    end
  end
end
