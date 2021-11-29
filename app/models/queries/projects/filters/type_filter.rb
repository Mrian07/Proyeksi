#-- encoding: UTF-8



module Queries
  module Projects
    module Filters
      class TypeFilter < ::Queries::Projects::Filters::ProjectFilter
        def allowed_values
          @allowed_values ||= Type.pluck(:name, :id)
        end

        def joins
          :types
        end

        def where
          operator_strategy.sql_for_field(values, Type.table_name, :id)
        end

        def type
          :list
        end

        def self.key
          :type_id
        end

        private

        def type_strategy
          # Instead of getting the IDs of all the projects a user is allowed
          # to see we only check that the value is an integer.  Non valid ids
          # will then simply create an empty result but will not cause any
          # harm.
          @type_strategy ||= ::Queries::Filters::Strategies::IntegerList.new(self)
        end
      end
    end
  end
end
