#-- encoding: UTF-8

module Queries
  module Projects
    module Filters
      class UserActionFilter < ::Queries::Projects::Filters::ProjectFilter
        def allowed_values
          @allowed_values ||= Action.default.pluck(:id, :id)
        end

        def type
          :list
        end

        def where
          capability_select = Capability
                                .where(action: values)
                                .where(principal: User.current)
                                .reselect(:context_id)

          sql_operator = if operator_class == ::Queries::Operators::Equals
                           "IN"
                         elsif operator_class == ::Queries::Operators::NotEquals
                           "NOT IN"
                         else
                           raise ArgumentError
                         end

          "#{Project.table_name}.id #{sql_operator} (#{capability_select.to_sql})"
        end
      end
    end
  end
end
