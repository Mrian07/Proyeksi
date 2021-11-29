#-- encoding: UTF-8



module Grids
  module Filters
    class ScopeFilter < Filters::GridFilter
      def allowed_values
        raise NotImplementedError, 'There would be too many candidates'
      end

      def allowed_values_subset
        grid_configs_of_values
          .map do |value, config|
          next unless config && config[:class]

          if config && config[:class]
            value
          end
        end.compact
      end

      def type
        :list
      end

      def where
        grid_configs_of_values
          .map do |_value, config|
          conditions = [class_condition(config[:class]),
                        project_id_condition(config[:project_id])]

          "(#{conditions.compact.join(' AND ')})"
        end.join(' OR ')
      end

      private

      def grid_configs_of_values
        values
          .map { |value| [value, ::Grids::Configuration.attributes_from_scope(value)] }
      end

      def class_condition(klass)
        return nil unless klass

        operator_strategy.sql_for_field([klass.name],
                                        self.class.model.table_name,
                                        'type')
      end

      def project_id_condition(project_id)
        return nil unless project_id

        unless project_id.match?(/\A\d+\z/)
          project_id = Project.find(project_id).id
        end

        operator_strategy.sql_for_field([project_id],
                                        self.class.model.table_name,
                                        'project_id')
      end

      def type_strategy
        @type_strategy ||= Queries::Filters::Strategies::HugeList.new(self)
      end

      def available_operators
        [::Queries::Operators::Equals]
      end
    end
  end
end
