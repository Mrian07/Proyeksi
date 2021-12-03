#-- encoding: UTF-8

module Queries
  module Relations
    module Filters
      class TypeFilter < ::Queries::Relations::Filters::RelationFilter
        def allowed_values
          ::Relation::TYPES.map do |_, value|
            [I18n.t(value[:name]), value[:sym]]
          end
        end

        def type
          :list
        end

        def self.key
          :type
        end

        def where
          Array(values).map do |value|
            column = Relation.relation_column(value)

            operator_strategy.sql_for_field(['1'],
                                            self.class.model.table_name,
                                            column)
          end.join(' OR ')
        end
      end
    end
  end
end
