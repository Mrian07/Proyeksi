

module ProyeksiApp::GithubIntegration
  module NotificationHandler
    ##
    # Handles GitHub issue comment notifications.
    class IssueComment
      include ProyeksiApp::GithubIntegration::NotificationHandler::Helper

      COMMENT_ACTIONS = %w[
        created
        edited
      ].freeze

      def process(params)
        @payload = wrap_payload(params)
        return unless associated_with_pr?

        github_system_user = User.find_by(id: payload.proyeksi_app_user_id)
        work_packages = find_mentioned_work_packages(payload.comment.body, github_system_user)
        new_work_packages = without_already_referenced(work_packages, pull_request)

        upsert_partial_pull_request(new_work_packages)
        comment_on_referenced_work_packages(new_work_packages, github_system_user, journal_entry) if new_work_packages.any?
      end

      private

      attr_reader :payload

      def associated_with_pr?
        payload.issue.pull_request?.present?
      end

      def pull_request
        @pull_request ||= GithubPullRequest.find_by(github_html_url: payload.issue.pull_request.html_url)
      end

      def upsert_partial_pull_request(work_packages)
        # Sadly, the webhook data for `issue_comment` events does not give us proper PR data (nor githubs PR id).
        # Thus, we have to search for the only data we have: html_url.
        # Even worse, when the PR is unknown to us, we don't have any useful data to create a GithubPullRequest record.
        # We still want to create a PR record (even if it just has partial data), to remember that it was referenced
        # and avoid adding reference-comments twice.
        ProyeksiApp::GithubIntegration::Services::UpsertPartialPullRequest.new.call(
          payload,
          work_packages: work_packages
        )
      end

      # rubocop:disable Metrics/AbcSize
      def journal_entry
        return unless COMMENT_ACTIONS.include?(payload.action)

        issue = payload.issue
        comment = payload.comment
        repository = payload.repository
        user = comment.user

        I18n.t("github_integration.pull_request_referenced_comment",
               pr_number: issue.number,
               pr_title: issue.title,
               pr_url: comment.html_url,
               repository: repository.full_name,
               repository_url: repository.html_url,
               github_user: user.login,
               github_user_url: user.html_url)
      end
      # rubocop:enable Metrics/AbcSize
    end
  end
end
