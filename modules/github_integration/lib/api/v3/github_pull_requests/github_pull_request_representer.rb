

require 'roar/decorator'
require 'roar/json/hal'

module API
  module V3
    module GithubPullRequests
      class GithubPullRequestRepresenter < ::API::Decorators::Single
        include API::Caching::CachedRepresenter
        include API::Decorators::DateProperty
        include API::Decorators::FormattableProperty
        include API::Decorators::LinkedResource

        def initialize(model, current_user:, **_opts)
          # We force `embed_links` so that github_user and github_check_runs
          # are embedded and we can avoid having separate endpoints.
          super(model, current_user: current_user, embed_links: true)
        end

        cached_representer key_parts: %i[github_user merged_by]

        property :id

        property :number

        property :github_html_url, as: :htmlUrl

        property :state,
                 render_nil: true

        property :repository,
                 render_nil: true

        date_time_property :github_updated_at,
                           render_nil: true,
                           setter: ->(*) { nil }

        property :title,
                 render_nil: true

        formattable_property :body,
                             render_nil: true

        property :draft,
                 render_nil: true

        property :merged,
                 render_nil: true

        property :merged_at,
                 render_nil: true

        property :comments_count,
                 render_nil: true

        property :review_comments_count,
                 render_nil: true

        property :additions_count,
                 render_nil: true

        property :deletions_count,
                 render_nil: true

        property :changed_files_count,
                 render_nil: true

        property :labels

        associated_resource :github_user,
                            representer: ::API::V3::GithubPullRequests::GithubUserRepresenter,
                            link_title_attribute: :github_login

        associated_resource :merged_by,
                            representer: ::API::V3::GithubPullRequests::GithubUserRepresenter,
                            v3_path: :github_user,
                            link_title_attribute: :github_login

        associated_resources :latest_check_runs,
                             as: :checkRuns,
                             representer: ::API::V3::GithubPullRequests::GithubCheckRunRepresenter,
                             v3_path: :github_check_run,
                             link_title_attribute: :name

        date_time_property :created_at

        date_time_property :updated_at

        def _type
          'GithubPullRequest'
        end

        self.to_eager_load = %i[github_user merged_by]
      end
    end
  end
end
