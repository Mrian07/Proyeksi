#-- encoding: UTF-8



module Queries
  module Relations
    module Filters
      class IdFilter < ::Queries::Relations::Filters::RelationFilter
        def type
          :integer
        end

        def self.key
          :id
        end
      end
    end
  end
end
