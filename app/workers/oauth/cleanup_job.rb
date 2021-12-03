#-- encoding: UTF-8

module OAuth
  class CleanupJob < ::Cron::CronJob
    include ::RakeJob

    # runs at 1:52 nightly
    self.cron_expression = '52 1 * * *'

    queue_with_priority :low

    def perform
      super 'doorkeeper:db:cleanup'
    end
  end
end
