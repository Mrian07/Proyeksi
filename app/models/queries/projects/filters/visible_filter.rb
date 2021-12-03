#-- encoding: UTF-8

# Returns projects visible for a user.
# This filter is only useful for admins which want to scope down the list of all the projects to those
# visible by a user. For a non admin user, the vanilla project query is already limited to the visible projects.
module Queries
  module Projects
    module Filters
      class VisibleFilter < ::Queries::Projects::Filters::ProjectFilter
        validate :validate_only_single_value

        def allowed_values
          # Disregard the need for a proper name (as it is no longer actually displayed)
          # in favor of speed.
          @allowed_values ||= User.pluck(:id, :id)
        end

        def scope
          super.where(id: Project.visible(User.find(values.first)))
        end

        def where
          # Handled by scope
          '1 = 1'
        end

        def type
          :list
        end

        def available_operators
          [::Queries::Operators::Equals]
        end

        private

        def validate_only_single_value
          errors.add(:values, :invalid) if values.length != 1
        end
      end
    end
  end
end
