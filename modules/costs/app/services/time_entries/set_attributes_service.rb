#-- encoding: UTF-8



module TimeEntries
  class SetAttributesService < ::BaseServices::SetAttributes
    private

    def set_attributes(attributes)
      super

      ##
      # Update project context if moving time entry
      if no_project_or_context_changed?
        model.project = model.work_package&.project
      end
    end

    def set_default_attributes(*)
      set_default_user
      set_default_activity
      set_default_hours
    end

    def set_default_user
      model.change_by_system do
        model.user = user
      end
    end

    def set_default_activity
      model.activity ||= TimeEntryActivity.default
    end

    def set_default_hours
      model.hours = nil if model.hours&.zero?
    end

    def no_project_or_context_changed?
      !model.project ||
        (model.work_package && model.work_package_id_changed? && !model.project_id_changed?)
    end
  end
end
