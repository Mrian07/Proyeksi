#-- encoding: UTF-8

# Only return Principals that are, direct or indirect humans.
# Includes
#   * User
#   * Group
module Principals::Scopes
  module Human
    extend ActiveSupport::Concern

    class_methods do
      def human
        where(type: [::User.name,
                     Group.name])
      end
    end
  end
end
