# frozen_string_literal: true

require "capybara/cuprite"

# Then, we need to register our driver to be able to use it later
# with #driven_by method.
Capybara.register_driver(:chrome) do |app|
  Capybara::Cuprite::Driver.new(
    app,
    **{
      window_size: [1280, 1400],
      # See additional options for Dockerized environment in the respective section of this article
      browser_options: {},
      # Increase Chrome startup wait time (required for stable CI builds)
      process_timeout: 10,
      # Enable debugging capabilities
      inspector: true,
      # Allow running Chrome in a headful mode by setting HEADLESS env
      # var to a falsey value
      headless: Config.headless?(default: true)
    }
  )
end

# Configure Capybara to use :cuprite driver by default
Capybara.default_driver = Capybara.javascript_driver = :chrome
Capybara.enable_aria_label = true
