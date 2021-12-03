#-- encoding: UTF-8

# Find a user account by matching case-insensitive.
module Users::Scopes
  module FindByLogin
    extend ActiveSupport::Concern

    class_methods do
      def by_login(login)
        where(["LOWER(login) = ?", login.to_s.downcase])
      end

      # Find a user scope by matching the exact login and then a case-insensitive
      # version. Exact matches will be given priority.
      def find_by_login(login)
        # First look for an exact match
        user = find_by(login: login)
        # Fail over to case-insensitive if none was found
        user || by_login(login).first
      end
    end
  end
end
