

module ProyeksiApp::Backlogs::Patches::SetAttributesServicePatch
  def self.included(base)
    base.prepend InstanceMethods
  end

  module InstanceMethods
    def set_attributes(attributes)
      super

      if work_package.parent_id_changed? &&
         work_package.parent_id &&
         !work_package.version_id_changed? &&
         work_package.in_backlogs_type?

        closest = closest_story_or_impediment(work_package.parent_id)
        work_package.version_id = closest.version_id if closest
      end
    end

    def closest_story_or_impediment(parent_id)
      return work_package if work_package.is_story? || work_package.is_impediment?

      closest = nil
      ancestor_chain(parent_id).each do |i|
        # break if we found an element in our chain that is not relevant in backlogs
        break unless i.in_backlogs_type?

        if i.is_story? || i.is_impediment?
          closest = i
          break
        end
      end
      closest
    end

    # ancestors array similar to Module#ancestors
    # i.e. returns immediate ancestors first
    def ancestor_chain(parent_id)
      ancestors = []
      unless parent_id.nil?
        real_parent = WorkPackage.find_by(id: parent_id)

        # Sort immediate ancestors first
        ancestors = real_parent
                    .ancestors
                    .includes(project: :enabled_modules)
                    .order_by_ancestors('desc')
                    .select('work_packages.*, COALESCE(max_depth.depth, 0)')

        ancestors = [real_parent] + ancestors
      end
      ancestors
    end
  end
end
