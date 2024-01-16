# frozen_string_literal: true

namespace :redis do
  desc "Clear the Redis database (through the Sidekiq connection)"
  task clear: :environment do
    Sidekiq.redis(&:flushdb)
  end
end
