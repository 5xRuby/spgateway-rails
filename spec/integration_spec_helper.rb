# frozen_string_literal: true
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../test_app/config/environment', __FILE__)
abort('The Rails environment is running in production mode!') if Rails.env.production?
require 'rails_helper'
require 'capybara/rspec'
require 'capybara/poltergeist'
Capybara.server_host = 'localhost'
Capybara.javascript_driver = :poltergeist
