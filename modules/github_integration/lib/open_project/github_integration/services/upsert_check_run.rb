#-- encoding: UTF-8


module OpenProject::GithubIntegration::Services
  ##
  # Takes check_run data coming from GitHub webhook data and stores
  # them as a `GithubCheckRun`.
  # If the `GithubCheckRun` already exists, it is updated.
  #
  # Returns the upserted `GithubCheckRun`.
  #
  # See: https://docs.github.com/en/developers/webhooks-and-events/webhook-events-and-payloads#check_run
  class UpsertCheckRun
    def call(payload, pull_request:)
      GithubCheckRun.find_or_initialize_by(github_id: payload.fetch('id'))
                    .tap do |check_run|
                      check_run.update!(github_pull_request: pull_request, **extract_params(payload))
                    end
    end

    private

    # Receives the input from the github webhook and translates them
    # to our internal representation.
    # See: https://docs.github.com/en/rest/reference/checks
    def extract_params(payload)
      output = payload.fetch('output')
      app = payload.fetch('app')

      {
        github_id: payload.fetch('id'),
        github_html_url: payload.fetch('html_url'),
        app_id: app.fetch('id'),
        github_app_owner_avatar_url: app.fetch('owner')
                                        .fetch('avatar_url'),
        name: payload.fetch('name'),
        status: payload.fetch('status'),
        conclusion: payload['conclusion'],
        output_title: output.fetch('title'),
        output_summary: output.fetch('summary'),
        details_url: payload['details_url'],
        started_at: payload['started_at'],
        completed_at: payload['completed_at']
      }
    end
  end
end
