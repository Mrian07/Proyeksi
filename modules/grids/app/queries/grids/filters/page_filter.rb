#-- encoding: UTF-8



module Grids
  module Filters
    class PageFilter < Filters::GridFilter
      def allowed_values
        raise NotImplementedError, 'There would be too many candidates'
      end

      def allowed_values_subset
        values
          .map { |page| [page, ::Grids::Configuration.attributes_from_scope(page)] }
          .map do |page, config|
            next unless config && config[:class]

            if config[:id] && config[:class].visible.exists?(config[:id]) || config[:class].visible.any?
              page
            end
          end.compact
      end

      def type
        :list
      end

      def self.key
        :page
      end

      # TODO: add condition methods for user_id and id
      def where
        values
          .map { |page| ::Grids::Configuration.attributes_from_scope(page) }
          .map do |actual_value|
            conditions = [class_condition(actual_value[:class]),
                          project_id_condition(actual_value[:project_id])]

            "(#{conditions.compact.join(' AND ')})"
          end.join(' OR ')
      end

      private

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

      def available_operators
        [::Queries::Operators::Equals]
      end

      def type_strategy
        @type_strategy ||= Queries::Filters::Strategies::HugeList.new(self)
      end
    end
  end
end
