# frozen_string_literal: true
module WaitFor
  def wait_for_ajax(max_wait_time: Capybara.default_max_wait_time)
    Timeout.timeout(max_wait_time) do
      loop until finished_all_ajax_requests?
    end
  end

  def wait_for_content(text, max_wait_time: Capybara.default_max_wait_time)
    Timeout.timeout(max_wait_time) do
      loop until page.has_content? text
    end
  end

  def finished_all_ajax_requests?
    page.evaluate_script('jQuery.active').zero?
  end
end

RSpec.configure do |config|
  config.include WaitFor, type: :feature
end
