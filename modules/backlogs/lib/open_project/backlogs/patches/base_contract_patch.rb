

module OpenProject::Backlogs::Patches::BaseContractPatch
  extend ActiveSupport::Concern

  included do
    attribute :remaining_hours
    attribute :story_points

    validate :validate_has_parents_version
    validate :validate_parent_work_package_relation

    private

    def validate_has_parents_version
      if model.is_task? &&
         model.parent && model.parent.in_backlogs_type? &&
         model.version_id != model.parent.version_id
        errors.add :version_id, :task_version_must_be_the_same_as_story_version
      end
    end

    def validate_parent_work_package_relation
      if model.parent && parent_work_package_relationship_spanning_projects?
        errors.add(:parent_id,
                   :parent_child_relationship_across_projects,
                   work_package_name: model.subject,
                   parent_name: model.parent.subject)
      end
    end

    def parent_work_package_relationship_spanning_projects?
      model.is_task? &&
        model.parent.in_backlogs_type? &&
        model.parent.project_id != model.project_id
    end
  end
end
