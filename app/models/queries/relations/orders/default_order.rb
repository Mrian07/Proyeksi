#-- encoding: UTF-8

module Queries
  module Relations
    module Orders
      class DefaultOrder < ::Queries::Orders::Base
        self.model = Relation

        def self.key
          /\A(id|from|to|involved|type)\z/
        end
      end
    end
  end
end
