#-- encoding: UTF-8



module Queries
  module GroupBys
    class NotExistingGroupBy < Base
      validate :always_false

      def self.key
        :inexistent
      end

      private

      def always_false
        errors.add :base, I18n.t(:'activerecord.errors.messages.does_not_exist')
      end
    end
  end
end
