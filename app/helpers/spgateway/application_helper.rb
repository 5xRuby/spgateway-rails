module Spgateway
  module ApplicationHelper
    def spgateway_mpg_form_for(
      mpg_form_object,
      submit: 'Go',
      submit_class: '',
      return_url: nil,
      mpg_gateway_url: Spgateway.config.mpg_gateway_url
    )
      unless mpg_form_object.is_a? Spgateway::MPGForm
        raise ArgumentError, "The first argument for 'pay2goo_form_for' must be a Spgateway::MPGForm."
      end

      mpg_form_object.return_url ||= return_url ||
                                     Spgateway::Engine.routes.url_helpers.mpg_callbacks_url(host: request.host, port: request.port)

      form_tag(mpg_gateway_url, method: :post) do
        mpg_form_object.sorted_params.each do |param_pair|
          name, value = param_pair
          concat hidden_field_tag name, value
        end

        concat hidden_field_tag :CheckValue, mpg_form_object.check_value

        concat submit_tag submit, class: submit_class
      end
    end
  end
end
