ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../../../Gemfile', __dir__)

require 'bundler/setup' if File.exist?(ENV['BUNDLE_GEMFILE'])
$LOAD_PATH.unshift File.expand_path('../../../lib', __dir__)

require "bootsnap/setup" # Speed up boot time by caching expensive operations.
