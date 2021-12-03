#-- encoding: UTF-8

module Queries
  module Filters
    class NotExistingFilter < Base
      def available?
        false
      end

      def type
        :inexistent
      end

      def self.key
        :not_existent
      end

      def human_name
        name.to_s.presence || type
      end

      validate :always_false

      def always_false
        errors.add :base, I18n.t(:'activerecord.errors.messages.does_not_exist')
      end

      # deactivating superclass validation
      def validate_inclusion_of_operator; end

      def to_hash
        {
          non_existent_filter: {
            operator: operator,
            values: values
          }
        }
      end

      def scope
        # TODO: remove switch once the WP query is a
        # subclass of Queries::Base
        model = if context.respond_to?(:model)
                  context.model
                else
                  WorkPackage
                end

        model.unscoped
      end

      def attributes_hash
        nil
      end
    end
  end
end
