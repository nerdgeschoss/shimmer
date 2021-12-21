# frozen_string_literal: true

require_relative "shimmer/version"
require_relative "shimmer/railtie" if defined?(Rails::Railtie)
Dir["#{File.expand_path("../lib/shimmer/middleware", __dir__)}/*"].each { |e| require e }

module Shimmer
  class Error < StandardError; end
  # Your code goes here...
end
