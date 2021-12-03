#-- encoding: UTF-8



module API
  module V3
    module GithubPullRequests
      class GithubPullRequestsByWorkPackageAPI < ::API::ProyeksiAppAPI
        after_validation do
          authorize(:show_github_content, context: @work_package.project)
          @github_pull_requests = @work_package.github_pull_requests
        end

        resources :github_pull_requests do
          get do
            path = api_v3_paths.github_pull_requests_by_work_package(@work_package.id)
            GithubPullRequestCollectionRepresenter.new(@github_pull_requests,
                                                       @github_pull_requests.count,
                                                       self_link: path,
                                                       current_user: current_user)
          end
        end
      end
    end
  end
end
