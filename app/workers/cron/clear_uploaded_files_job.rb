#-- encoding: UTF-8



module Cron
  class ClearUploadedFilesJob < CronJob
    include ::RakeJob

    # Runs 23pm fridays
    self.cron_expression = '0 23 * * 5'

    def perform
      super 'attachments:clear'
    end
  end
end
