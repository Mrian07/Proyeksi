#-- encoding: UTF-8



module TimeEntries
  class BaseContract < ::ModelContract
    include AssignableValuesContract
    include AssignableCustomFieldValues

    delegate :work_package,
             :project,
             :available_custom_fields,
             :new_record?,
             to: :model

    def self.model
      TimeEntry
    end

    validate :validate_hours_are_in_range
    validate :validate_project_is_set
    validate :validate_work_package

    attribute :project_id
    attribute :work_package_id
    attribute :activity_id do
      validate_activity_active
    end
    attribute :hours
    attribute :comments
    attribute_alias :comments, :comment

    attribute :spent_on
    attribute :tyear
    attribute :tmonth
    attribute :tweek

    def assignable_activities
      if !model.project
        TimeEntryActivity.none
      else
        TimeEntryActivity.active_in_project(model.project)
      end
    end

    # Necessary for custom fields
    # of type version.
    def assignable_versions
      work_package.try(:assignable_versions) || project.try(:assignable_versions) || []
    end

    private

    def validate_work_package
      return unless model.work_package || model.work_package_id_changed?

      if work_package_invisible? ||
         work_package_not_in_project?
        errors.add :work_package_id, :invalid
      end
    end

    def validate_hours_are_in_range
      errors.add :hours, :invalid if model.hours&.negative?
    end

    def validate_project_is_set
      errors.add :project_id, :invalid if model.project.nil?
    end

    def validate_activity_active
      errors.add :activity_id, :inclusion if model.activity_id && !assignable_activities.exists?(model.activity_id)
    end

    def work_package_invisible?
      model.work_package.nil? || !model.work_package.visible?(user)
    end

    def work_package_not_in_project?
      model.work_package && model.project != model.work_package.project
    end
  end
end
