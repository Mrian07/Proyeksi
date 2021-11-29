

require 'roar/decorator'
require 'roar/json/hal'

module API
  module V3
    module GithubPullRequests
      class GithubCheckRunRepresenter < ::API::Decorators::Single
        include API::Caching::CachedRepresenter
        include API::Decorators::DateProperty

        self_link id_attribute: :id,
                  title_getter: ->(*) { nil }

        property :github_html_url, as: :htmlUrl
        property :github_app_owner_avatar_url, as: :appOwnerAvatarUrl
        property :name
        property :status
        property :conclusion
        property :output_title
        property :output_summary
        property :details_url

        date_time_property :started_at
        date_time_property :completed_at

        def _type
          'GithubCheckRun'
        end
      end
    end
  end
end
