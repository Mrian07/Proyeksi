

require_relative './notification_handler/helper'
require_relative './notification_handler/issue_comment'
require_relative './notification_handler/pull_request'

module ProyeksiApp::GithubIntegration
  ##
  # Handles github-related notifications.
  # Each method is named after their webhook "event" as documented here:
  # https://docs.github.com/en/developers/webhooks-and-events/webhook-events-and-payloads
  module NotificationHandler
    class << self
      def check_run(payload)
        with_logging do
          ProyeksiApp::GithubIntegration::NotificationHandler::CheckRun.new.process(payload)
        end
      end

      def issue_comment(payload)
        with_logging do
          ProyeksiApp::GithubIntegration::NotificationHandler::IssueComment.new.process(payload)
        end
      end

      def pull_request(payload)
        with_logging do
          ProyeksiApp::GithubIntegration::NotificationHandler::PullRequest.new.process(payload)
        end
      end

      private

      def with_logging
        yield if block_given?
      rescue StandardError => e
        Rails.logger.error "Failed to handle issue_comment event: #{e} #{e.message}"
        raise e
      end
    end
  end
end
