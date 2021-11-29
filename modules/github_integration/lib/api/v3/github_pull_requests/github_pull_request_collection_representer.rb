#-- encoding: UTF-8



module API
  module V3
    module GithubPullRequests
      class GithubPullRequestCollectionRepresenter < ::API::Decorators::Collection
        self.to_eager_load = ::API::V3::GithubPullRequests::GithubPullRequestRepresenter.to_eager_load
      end
    end
  end
end
