#-- encoding: UTF-8

module Queries
  module Relations
    module Filters
      class ToFilter < ::Queries::Relations::Filters::RelationFilter
        include ::Queries::Relations::Filters::VisibilityChecking

        def type
          :integer
        end

        def self.key
          :to_id
        end

        def visibility_checked?
          true
        end

        private

        def visibility_checked_sql(operator, values, visible_sql)
          ["to_id #{operator} (?) AND from_id IN (#{visible_sql})", values]
        end
      end
    end
  end
end
