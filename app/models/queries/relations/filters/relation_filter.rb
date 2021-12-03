#-- encoding: UTF-8

module Queries
  module Relations
    module Filters
      class RelationFilter < ::Queries::Filters::Base
        self.model = Relation

        def human_name
          Relation.human_attribute_name(name)
        end

        def visibility_checked?
          false
        end
      end
    end
  end
end
