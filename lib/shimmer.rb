require_relative "shimmer/version"
require_relative "shimmer/railtie" if defined?(Rails::Railtie)
Dir["#{File.expand_path("../lib/shimmer/middlewares", __dir__)}/*"].sort.each { |e| require e }
Dir["#{File.expand_path("../lib/shimmer/controllers", __dir__)}/*"].sort.each { |e| require e }
Dir["#{File.expand_path("../lib/shimmer/jobs", __dir__)}/*"].sort.each { |e| require e }
Dir["#{File.expand_path("../lib/shimmer/utils", __dir__)}/*"].sort.each { |e| require e }
require_relative "shimmer/auth"
require_relative "shimmer/form"

module Shimmer
  class Error < StandardError; end
  # Your code goes here...
end
