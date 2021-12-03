module PlaceholderUsers
  class PlaceholderUserFilterCell < IndividualPrincipalBaseFilterCell
    options :roles, :clear_url, :project

    class << self
      def base_query
        Queries::PlaceholderUsers::PlaceholderUserQuery
      end

      def apply_filters(params, query)
        super

        # Filter for active placeholders
        # to skip to-be-deleted users
        query.where(:status, '=', :active)
      end
    end

    # INSTANCE METHODS:

    def filter_path
      placeholder_users_path
    end
  end
end
