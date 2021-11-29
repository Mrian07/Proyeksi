

module OpenProject::GithubIntegration
  class HookHandler
    # List of the github events we can handle.
    KNOWN_EVENTS = %w[
      check_run
      issue_comment
      ping
      pull_request
    ].freeze

    # A github webhook happened.
    # We need to check validity of the data and send a Notification
    # to be processed in our `NotificationHandler`.
    def process(_hook, request, params, user)
      event_type = request.env['HTTP_X_GITHUB_EVENT']
      event_delivery = request.env['HTTP_X_GITHUB_DELIVERY']

      Rails.logger.debug "Received github webhook #{event_type} (#{event_delivery})"

      return 404 unless KNOWN_EVENTS.include?(event_type) && event_delivery
      return 403 if user.blank?

      payload = params[:payload]
                .permit!
                .to_h
                .merge('open_project_user_id' => user.id,
                       'github_event' => event_type,
                       'github_delivery' => event_delivery)

      OpenProject::Notifications.send("github.#{event_type}", payload)

      200
    end
  end
end
