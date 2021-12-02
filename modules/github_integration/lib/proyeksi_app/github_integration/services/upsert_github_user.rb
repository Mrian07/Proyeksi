#-- encoding: UTF-8


module ProyeksiApp::GithubIntegration::Services
  ##
  # Takes user data coming from GitHub webhook data and stores
  # them as a `GithubUser`.
  # If the `GithubUser` already exists, it is updated.
  #
  # Returns the upserted `GithubUser`.
  #
  # See: https://docs.github.com/en/developers/webhooks-and-events/webhook-events-and-payloads#pull_request
  class UpsertGithubUser
    def call(payload)
      GithubUser.find_or_initialize_by(github_id: payload.fetch('id'))
                .tap do |github_user|
                  github_user.update!(extract_params(payload))
                end
    end

    private

    ##
    # Receives the input from the github webhook and translates them
    # to our internal representation.
    # See: https://docs.github.com/en/rest/reference/users
    def extract_params(payload)
      {
        github_id: payload.fetch('id'),
        github_login: payload.fetch('login'),
        github_html_url: payload.fetch('html_url'),
        github_avatar_url: payload.fetch('avatar_url')
      }
    end
  end
end
