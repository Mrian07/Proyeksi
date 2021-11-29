

module OpenProject::GithubIntegration
  module NotificationHandler
    ##
    # Handles GitHub pull request notifications.
    class PullRequest
      include OpenProject::GithubIntegration::NotificationHandler::Helper

      COMMENT_ACTIONS = %w[
        closed
        opened
        ready_for_review
        reopened
      ].freeze

      def process(params)
        @payload = wrap_payload(params)
        github_system_user = User.find_by(id: payload.open_project_user_id)
        work_packages = find_mentioned_work_packages(payload.pull_request.body, github_system_user)

        comment_on_referenced_work_packages(
          work_packages_to_comment_on(payload.action, work_packages),
          github_system_user,
          journal_entry
        )
        upsert_pull_request(work_packages)
      end

      private

      attr_reader :payload

      def work_packages_to_comment_on(action, work_packages)
        if action == 'edited'
          without_already_referenced(work_packages, pull_request)
        else
          COMMENT_ACTIONS.include?(action) ? work_packages : []
        end
      end

      def pull_request
        @pull_request ||= GithubPullRequest
                            .where(github_id: payload.pull_request.id)
                            .or(GithubPullRequest.where(github_html_url: payload.pull_request.html_url))
                            .take
      end

      def upsert_pull_request(work_packages)
        return if work_packages.empty? && pull_request.nil?

        OpenProject::GithubIntegration::Services::UpsertPullRequest.new.call(payload.pull_request.to_h,
                                                                             work_packages: work_packages)
      end

      def journal_entry
        key = journal_entry_i18n_key
        return nil unless key

        pull_request = payload.pull_request
        repository = pull_request.base.repo
        sender = payload.sender

        I18n.t("github_integration.pull_request_#{key}_comment",
               pr_number: pull_request.number,
               pr_title: pull_request.title,
               pr_url: pull_request.html_url,
               repository: repository.full_name,
               repository_url: repository.html_url,
               github_user: sender.login,
               github_user_url: sender.html_url)
      end

      def journal_entry_i18n_key
        key = {
          'opened' => 'opened',
          'reopened' => 'opened',
          'closed' => 'closed',
          'edited' => 'referenced',
          'referenced' => 'referenced',
          'ready_for_review' => 'ready_for_review'
        }[payload.action]

        return 'merged' if key == 'closed' && payload.pull_request.merged
        return 'draft' if key == 'open' && payload.pull_request.draft

        key
      end
    end
  end
end
