#-- encoding: UTF-8


module ProyeksiApp::GithubIntegration::Services
  ##
  # Takes pull request data coming from GitHub webhook data and stores
  # them as a `GithubPullRequest`.
  # issue_comments webhooks don't give us the full PR data, but just a a subset, e.g. html_url, state and title
  # As described in [the docs](https://docs.github.com/en/rest/reference/issues#list-organization-issues-assigned-to-the-authenticated-user),
  # pull request are considered to also be issues.
  #
  # Returns the upserted partial `GithubPullRequest`.
  class UpsertPartialPullRequest
    def call(payload, work_packages:)
      params = extract_params(payload)

      find_or_initialize(params[:github_html_url]).tap do |pr|
        pr.update!(work_packages: pr.work_packages | work_packages, **extract_params(payload))
      end
    end

    private

    def extract_params(payload)
      {
        github_html_url: payload.issue.pull_request.html_url,
        github_updated_at: payload.issue.updated_at,
        github_user: github_user_id(payload.issue.user.to_h),
        number: payload.issue.number,
        state: payload.issue.state,
        repository: payload.repository.full_name,
        title: payload.issue.title
      }
    end

    def find_or_initialize(github_html_url)
      GithubPullRequest.find_or_initialize_by(github_html_url: github_html_url)
    end

    def github_user_id(payload)
      return if payload.blank?

      ::ProyeksiApp::GithubIntegration::Services::UpsertGithubUser.new.call(payload)
    end
  end
end
