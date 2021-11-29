#-- encoding: UTF-8



module Queries
  module Relations
    module Filters
      module VisibilityChecking
        def visibility_checked?
          true
        end

        def where
          integer_values = values.map(&:to_i)

          visible_sql = WorkPackage.visible(User.current).select(:id).to_sql

          operator_string = case operator
                            when "="
                              "IN"
                            when "!"
                              "NOT IN"
                            end

          visibility_checked_sql(operator_string, values, visible_sql)
        end

        private

        def visibility_checked_sql(_operator, _values, _visible_sql)
          raise NotImplementedError
        end
      end
    end
  end
end
