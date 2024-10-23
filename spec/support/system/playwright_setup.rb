# frozen_string_literal: true

Capybara.register_driver(:custom_playwright) do |app|
  Capybara::Playwright::Driver.new(app,
    browser_type: :chromium,
    headless: !!Config.ci?)
end

Capybara.default_driver = Capybara.javascript_driver = :custom_playwright
Capybara.enable_aria_label = true
