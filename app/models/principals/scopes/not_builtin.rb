#-- encoding: UTF-8

# Only return Principals that are not built into the system so only return those that where
# created by a human.
# Excludes
#   * DeletedUser
#   * SystemUser
#   * AnonymousUser
module Principals::Scopes
  module NotBuiltin
    extend ActiveSupport::Concern

    class_methods do
      def not_builtin
        where.not(type: [SystemUser.name,
                         AnonymousUser.name,
                         DeletedUser.name])
      end
    end
  end
end
