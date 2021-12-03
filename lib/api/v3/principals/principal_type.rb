#-- encoding: UTF-8

module API
  module V3
    module Principals
      class PrincipalType
        ##
        # Return the appropriate API level type
        # that depend on the AR type of the principal passed in.
        def self.for(principal)
          case principal
          when User
            :user
          when Group
            :group
          when PlaceholderUser
            :placeholder_user
          when NilClass
            # Fall back to user for unknown principal
            # since we do not have a principal route.
            :user
          else
            raise "undefined subclass for #{principal}"
          end
        end
      end
    end
  end
end
