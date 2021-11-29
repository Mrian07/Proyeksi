#-- encoding: UTF-8



module Cron
  class ClearOldPullRequestsJob < CronJob
    priority_number :low

    # runs at 1:25 nightly
    self.cron_expression = '25 1 * * *'

    def perform
      GithubPullRequest.without_work_package
                       .find_each(&:destroy!)
    end
  end
end
