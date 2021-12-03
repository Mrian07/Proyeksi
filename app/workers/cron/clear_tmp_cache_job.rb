#-- encoding: UTF-8

module Cron
  class ClearTmpCacheJob < CronJob
    include ::RakeJob

    # runs at 02:45 sundays
    self.cron_expression = '45 2 * * 7'

    def perform
      super 'tmp:cache:clear'
    end
  end
end
