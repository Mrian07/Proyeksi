#-- encoding: UTF-8



# Only return Principals that are of type User
module Principals::Scopes
  module User
    extend ActiveSupport::Concern

    class_methods do
      def user
        # Have to use the User model here so that the scopes defined on User
        # are also available after the scope is used.
        where(type: [::User.name])
      end
    end
  end
end
