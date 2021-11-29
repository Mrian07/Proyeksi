

module Projects
  module Archiver
    # Check that there is no wp of a non descendant project that is assigned
    # to one of the project or descendant versions
    def validate_no_foreign_wp_references
      version_ids = model.rolled_up_versions.select(:id)

      exists = WorkPackage
                 .where.not(project_id: model.self_and_descendants.select(:id))
                 .where(version_id: version_ids)
                 .exists?

      errors.add :base, :foreign_wps_reference_version if exists
    end

    def validate_all_ancestors_active
      if model.ancestors.any?(&:archived?)
        errors.add :base, :archived_ancestor
      end
    end
  end
end
