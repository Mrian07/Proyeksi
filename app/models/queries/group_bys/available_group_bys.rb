#-- encoding: UTF-8

module Queries
  module GroupBys
    module AvailableGroupBys
      def group_by_for(key)
        (find_registered_group_by(key) || ::Queries::GroupBys::NotExistingGroupBy).new(key)
      end

      private

      def find_registered_group_by(key)
        group_by_register.detect do |s|
          s.key === key.to_sym
        end
      end

      def group_by_register
        ::Queries::Register.group_bys[self.class]
      end
    end
  end
end
