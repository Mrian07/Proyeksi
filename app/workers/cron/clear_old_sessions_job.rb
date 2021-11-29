#-- encoding: UTF-8



module Cron
  class ClearOldSessionsJob < CronJob
    include ::RakeJob

    # runs at 1:15 nightly
    self.cron_expression = '15 1 * * *'

    def perform
      super 'db:sessions:expire', 7
    end
  end
end
