module Actions::Scopes
  module Default
    extend ActiveSupport::Concern

    class_methods do
      def default
        capabilities_sql = <<~SQL
          (SELECT id, permission, global, module FROM (VALUES #{action_map}) AS t(id, permission, global, module)) actions
        SQL

        select('actions.*')
          .from(capabilities_sql)
      end

      private

      def action_map
        ProyeksiApp::AccessControl
          .contract_actions_map
          .map { |permission, v| map_actions(permission, v[:actions], v[:global], v[:module]) }
          .flatten
          .join(', ')
      end

      def map_actions(permission, actions, global, module_name)
        actions.map do |namespace, actions|
          actions.map do |action|
            values = [quote_string("#{action_v3_name(namespace)}/#{action}"),
                      quote_string(permission),
                      global,
                      module_name ? quote_string(module_name) : 'NULL'].join(', ')

            "(#{values})"
          end
        end
      end

      def action_v3_name(name)
        API::Utilities::PropertyNameConverter.from_ar_name(name.to_s.singularize).pluralize.underscore
      end

      def quote_string(string)
        ActiveRecord::Base.connection.quote(string.to_s)
      end
    end
  end
end
