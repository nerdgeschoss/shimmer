# frozen_string_literal: true

require "pry"
require "pry-byebug"

require "dotenv/load"
Dotenv.load! ".env", ".env.test"

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].sort.each { |f| require f }

ENV["RAILS_ENV"] = "test"

require_relative "../spec/dummy/config/environment"
ENV["RAILS_ROOT"] ||= "#{File.dirname(__FILE__)}../../../spec/dummy"
require "dotenv/rails-now"
