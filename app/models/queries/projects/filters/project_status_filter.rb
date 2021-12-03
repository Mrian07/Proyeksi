#-- encoding: UTF-8

module Queries
  module Projects
    module Filters
      class ProjectStatusFilter < ::Queries::Projects::Filters::ProjectFilter
        include ProjectStatusHelper

        def allowed_values
          @allowed_values ||= ::Projects::Status.codes.map do |code, id|
            [project_status_name_for_code(code), id.to_s]
          end
        end

        def left_outer_joins
          :status
        end

        def where
          operator_strategy.sql_for_field(values, ::Projects::Status.table_name, :code)
        end

        def type
          :list_optional
        end

        def self.key
          :project_status_code
        end

        def human_name
          I18n.t('js.grid.widgets.project_status.title')
        end
      end
    end
  end
end
