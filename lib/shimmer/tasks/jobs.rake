# frozen_string_literal: true

namespace :jobs do
  desc "Set all jobs to be inlined (bypass the configured ActiveJob Queue Adapter)"
  task inline: :environment do
    ActiveJob::Base.queue_adapter = Shimmer::InlineIgnoreScheduledActiveJobsAdapter.new
  end

  desc "Output jobs detail to the console"
  task list: :environment do
    jobs_filter = ENV.fetch("JOB_CLASS", "").split(",").filter_map(&:presence).to_set.presence

    known_job_sets = {
      enqueued: Sidekiq::Queue,
      retries: Sidekiq::RetrySet,
      scheduled: Sidekiq::ScheduledSet,
      dead: Sidekiq::DeadSet
    }
    job_sets = ENV.fetch("SETS", "").split(",")&.filter_map { |s| known_job_sets.fetch(s.to_sym) } || known_job_sets.values

    result = job_sets.map do |set_class|
      set = set_class.new
      jobs = set
        .filter { |job| jobs_filter.nil? || jobs_filter.include?(job.item.dig("args", 0, "job_class")) }
        .map(&:as_json)
      [set_class.name, jobs]
    end.to_h

    puts JSON.pretty_generate(result)
  end

  namespace :delete do
    desc "Remove all instances of a specific job from all queues and sets"
    task all: :environment do
      job_class = ENV["JOB_CLASS"].presence || raise(ArgumentError, "Environment variable JOB_CLASS must be provided")
      SidekiqJobs.delete_all(job_class)
    end

    desc "Remove all instances of a specific job from all queues"
    task enqueued: :environment do
      job_class = ENV["JOB_CLASS"].presence || raise(ArgumentError, "Environment variable JOB_CLASS must be provided")
      SidekiqJobs.delete_enqueued(job_class)
    end

    desc "Remove all instances of a specific job from the scheduled set"
    task scheduled: :environment do
      job_class = ENV["JOB_CLASS"].presence || raise(ArgumentError, "Environment variable JOB_CLASS must be provided")
      SidekiqJobs.delete_scheduled(job_class)
    end

    desc "Remove all instances of a specific job from the retry set"
    task retry: :environment do
      job_class = ENV["JOB_CLASS"].presence || raise(ArgumentError, "Environment variable JOB_CLASS must be provided")
      SidekiqJobs.delete_retry(job_class)
    end
  end
end
