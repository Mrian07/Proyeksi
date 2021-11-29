

require 'roar/decorator'
require 'roar/json/hal'

module API
  module V3
    module GithubPullRequests
      class GithubUserRepresenter < ::API::Decorators::Single
        include API::Caching::CachedRepresenter

        self_link id_attribute: :id,
                  title_getter: ->(*) { nil }

        property :github_login, as: :login
        property :github_html_url, as: :htmlUrl
        property :github_avatar_url, as: :avatarUrl

        def _type
          'GithubUser'
        end
      end
    end
  end
end
