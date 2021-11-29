

module OpenProject::GithubIntegration
  module NotificationHandler
    ##
    # Handles GitHub issue comment notifications.
    class CheckRun
      include OpenProject::GithubIntegration::NotificationHandler::Helper

      def process(params)
        @payload = wrap_payload(params)
        return unless associated_with_pr?

        pull_request = find_pull_request
        return unless pull_request

        OpenProject::GithubIntegration::Services::UpsertCheckRun.new.call(
          payload.check_run.to_h,
          pull_request: pull_request
        )
      end

      private

      attr_reader :payload

      def associated_with_pr?
        payload.check_run.pull_requests?.present?
      end

      def find_pull_request
        github_id = payload.check_run
                           .pull_requests
                           .first
                           .fetch('id')
        GithubPullRequest.find_by(github_id: github_id)
      end
    end
  end
end
