#-- encoding: UTF-8



module WorkPackages
  class UpdateContract < BaseContract
    include UnchangedProject

    attribute :lock_version,
              permission: %i[edit_work_packages assign_versions manage_subtasks move] do
      if model.lock_version.nil? || model.lock_version_changed?
        errors.add :base, :error_conflict
      end
    end

    validate :user_allowed_to_access

    validate :user_allowed_to_edit

    validate :can_move_to_milestone

    default_attribute_permission :edit_work_packages
    attribute_permission :project_id, :move_work_packages

    private

    def user_allowed_to_edit
      with_unchanged_project_id do
        next if @can.allowed?(model, :edit) ||
                @can.allowed?(model, :assign_version) ||
                @can.allowed?(model, :manage_subtasks) ||
                @can.allowed?(model, :move)
        next if allowed_journal_addition?

        errors.add :base, :error_unauthorized
      end
    end

    def user_allowed_to_access
      unless ::WorkPackage.visible(@user).exists?(model.id)
        errors.add :base, :error_not_found
      end
    end

    def allowed_journal_addition?
      model.changes.empty? && model.journal_notes && can.allowed?(model, :comment)
    end

    def can_move_to_milestone
      return unless model.type_id_changed? && model.milestone?

      if model.children.any?
        errors.add :type, :cannot_be_milestone_due_to_children
      end
    end
  end
end
