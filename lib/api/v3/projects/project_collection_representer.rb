#-- encoding: UTF-8

require 'roar/decorator'
require 'roar/json'
require 'roar/json/collection'
require 'roar/json/hal'

module API
  module V3
    module Projects
      class ProjectCollectionRepresenter < ::API::Decorators::OffsetPaginatedCollection
        self.to_eager_load = ::API::V3::Projects::ProjectRepresenter.to_eager_load
        self.checked_permissions = ::API::V3::Projects::ProjectRepresenter.checked_permissions

        def initialize(represented, self_link:, current_user:, query: {}, page: nil, per_page: nil, groups: nil)
          super

          @represented = ::API::V3::Projects::ProjectEagerLoadingWrapper.wrap(represented)
        end

        links :representations do
          [
            representation_format_csv,
            representation_format_xls
          ]
        end

        def representation_format(format, mime_type:)
          {
            href: url_for(controller: :projects, action: :index, format: format, **query_params),
            identifier: format,
            type: mime_type,
            title: I18n.t("export.format.#{format}")
          }
        end

        def representation_format_xls
          representation_format 'xls',
                                mime_type: 'application/vnd.ms-excel'
        end

        def representation_format_csv
          representation_format 'csv',
                                mime_type: 'text/csv'
        end
      end
    end
  end
end
