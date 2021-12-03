

module ProyeksiApp::Backlogs::Patches::UpdateServicePatch
  def self.included(base)
    base.prepend InstanceMethods
  end

  module InstanceMethods
    def update_descendants
      super_result = super

      if work_package.in_backlogs_type? && work_package.version_id_changed?
        inherit_version_to_descendants(super_result)
      end

      super_result
    end

    def inherit_version_to_descendants(result)
      all_descendants = work_package
                          .descendants
                          .includes(:parent_relation, project: :enabled_modules)
                          .order(Arel.sql('relations.hierarchy asc'))
                          .select('work_packages.*, relations.hierarchy')
      stop_descendants_ids = []

      descendant_tasks = all_descendants.reject do |t|
        if stop_descendants_ids.include?(t.parent_relation.from_id) || !t.is_task?
          stop_descendants_ids << t.id
        end
      end

      attributes = { version_id: work_package.version_id }

      descendant_tasks.each do |task|
        # Ensure the parent is already moved to new version so that validation errors are avoided.
        task.parent = ([work_package] + all_descendants).detect { |d| d.id == task.parent_id }
        result.add_dependent!(set_attributes(attributes, task))
      end
    end
  end
end
