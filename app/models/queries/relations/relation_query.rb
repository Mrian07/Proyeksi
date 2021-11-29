

module Queries
  module Relations
    class RelationQuery < ::Queries::BaseQuery
      def self.model
        Relation
      end

      def default_scope
        Relation
          .direct
      end

      def results
        # Filters marked to already check visibility free us from the need
        # to check it here.

        if filters.any?(&:visibility_checked?)
          super
        else
          super.visible
        end
      end
    end
  end
end
