# frozen_string_literal: true

require "pry"
require "pry-byebug"
require "spec_helper"

ENV["RAILS_ENV"] ||= "test"
require_relative "rails_app/config/environment"
ENV["RAILS_ROOT"] ||= "#{File.dirname(__FILE__)}/rails_app"
abort("The Rails environment is running in production mode!") if Rails.env.production?

require "rspec/rails"
# require "slim-rails"
Dir[File.expand_path("spec/support/**/*.rb")].sort.each { |f| require f }

begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  puts e.to_s.strip
  exit 1
end

RSpec.configure do |config|
  config.include ActiveSupport::Testing::TimeHelpers
  config.include ActiveJob::TestHelper

  config.fixture_path = File.expand_path("./spec/fixtures", __dir__)
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!

  config.around do |example|
    example.run
    Rails.cache.clear
  end
end
