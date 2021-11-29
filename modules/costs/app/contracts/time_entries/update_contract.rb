#-- encoding: UTF-8



module TimeEntries
  class UpdateContract < BaseContract
    include UnchangedProject

    validate :validate_user_allowed_to_update

    def validate_user_allowed_to_update
      unless user_allowed_to_update?
        errors.add :base, :error_unauthorized
      end
    end

    ##
    # Users may update time entries IF
    # they have the :edit_time_entries or
    # user == editing user and :edit_own_time_entries
    def user_allowed_to_update?
      with_unchanged_project_id do
        user_allowed_to_update_in?(model.project)
      end && user_allowed_to_update_in?(model.project)
    end

    private

    def user_allowed_to_update_in?(project)
      user.allowed_to?(:edit_time_entries, project) ||
        (model.user == user && user.allowed_to?(:edit_own_time_entries, project))
    end
  end
end
