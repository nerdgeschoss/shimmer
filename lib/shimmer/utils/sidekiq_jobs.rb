# frozen_string_literal: true

module Shimmer
  module SidekiqJobs
    # Removes all instances of a specific job from all queues and sets.
    def self.delete_all(job_class)
      delete_enqueued(job_class) +
        delete_scheduled(job_class) +
        delete_retry(job_class)
    end

    # Removes all instances of a specific job from the queue.
    def self.delete_enqueued(job_class)
      job_class = (job_class.is_a?(Class) ? job_class.name : job_class).presence || raise(ArgumentError, "Argument job_class must be provided")
      Sidekiq::Queue.all.flat_map do |queue|
        queue.filter { |job| job.args.any? { |args| args.fetch("job_class") == job_class } }.each(&:delete)
      end
    end

    # Removes all instances of a specific job from the scheduled set.
    def self.delete_scheduled(job_class)
      job_class = (job_class.is_a?(Class) ? job_class.name : job_class).presence || raise(ArgumentError, "Argument job_class must be provided")
      Sidekiq::ScheduledSet.new.filter { |job| job.args.any? { |args| args.fetch("job_class") == job_class } }.each(&:delete)
    end

    # Removes all instances of a specific job from the retry set.
    def self.delete_retry(job_class)
      job_class = (job_class.is_a?(Class) ? job_class.name : job_class).presence || raise(ArgumentError, "Argument job_class must be provided")
      Sidekiq::RetrySet.new.filter { |job| job.args.any? { |args| args.fetch("job_class") == job_class } }.each(&:delete)
    end
  end
end
