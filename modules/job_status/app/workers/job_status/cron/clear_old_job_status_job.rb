#-- encoding: UTF-8



module JobStatus
  module Cron
    class ClearOldJobStatusJob < ::Cron::CronJob
      # runs at 4:15 nightly
      self.cron_expression = '15 4 * * *'

      RETENTION_PERIOD = 2.days.freeze

      def perform
        ::JobStatus::Status
          .where(::JobStatus::Status.arel_table[:updated_at].lteq(Time.now - RETENTION_PERIOD))
          .destroy_all
      end
    end
  end
end
