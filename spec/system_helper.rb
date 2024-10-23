# frozen_string_literal: true

require "rails_helper"
require "rack_session_access/capybara"
require "rspec/retry"

Rails.application.routes.default_url_options[:locale] = :en

RSpec.configure do |config|
  config.before(:each, type: :system) do
    driven_by Capybara.javascript_driver
  end

  Capybara.app_host = "http://localhost"

  # rspec-retry
  config.verbose_retry = true
  config.default_retry_count = ENV["CI"] ? 3 : 0
  config.display_try_failure_messages = true
  config.default_sleep_interval = ENV.fetch("RSPEC_RETRY_SLEEP_INTERVAL", 0).to_i
  config.retry_callback = proc do
    Capybara.reset!
  end
end
