class PagesController < ApplicationController
  def credit_card_payment_button
  end

  def done
    if params[:data]
      @data = JSON.pretty_generate(JSON.parse(params[:data]))
    end
  end
end
