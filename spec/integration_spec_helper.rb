# frozen_string_literal: true
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../test_app/config/environment', __FILE__)
abort('The Rails environment is running in production mode!') if Rails.env.production?
require 'rails_helper'
require 'capybara/rspec'
require 'capybara/poltergeist'
require 'ngrok/rspec'
Capybara.server_port = 3003
Capybara.javascript_driver = :poltergeist
Ngrok::Rspec.tunnel = { port: Capybara.server_port }
RSpec.configure { |config| config.include Ngrok::Rspec }
