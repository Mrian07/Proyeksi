#-- encoding: UTF-8



module Queries
  module Relations
    module Filters
      class FromFilter < ::Queries::Relations::Filters::RelationFilter
        include ::Queries::Relations::Filters::VisibilityChecking

        def type
          :integer
        end

        def self.key
          :from_id
        end

        private

        def visibility_checked_sql(operator, values, visible_sql)
          ["from_id #{operator} (?) AND to_id IN (#{visible_sql})", values]
        end
      end
    end
  end
end
