# frozen_string_literal: true

module Shimmer
  class InlineIgnoreScheduledActiveJobsAdapter < ActiveJob::QueueAdapters::InlineAdapter
    def enqueue_at(job, *)
      Rails.logger.debug "Ignored future job enqueuing of #{job.class.name} with arguments #{job.arguments}"
    end
  end
end
