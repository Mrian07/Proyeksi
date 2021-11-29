#-- encoding: UTF-8



module Members::Scopes
  module Assignable
    extend ActiveSupport::Concern

    class_methods do
      # Find all members that are whose principals are not locked and have an
      # assignable role.
      def assignable
        not_locked
          .includes(:roles)
          .references(:roles)
          .where(roles: { assignable: true })
      end
    end
  end
end
