

module OpenProject::Backlogs::Patches::UpdateAncestorsServicePatch
  def self.included(base)
    base.prepend InstanceMethods
  end

  module InstanceMethods
    private

    ##
    # Overrides method in original UpdateAncestorsService.
    def inherit_attributes(ancestor, attributes)
      super

      inherit_remaining_hours(ancestor) if inherit?(attributes, :remaining_hours)
    end

    def inherit_remaining_hours(ancestor)
      ancestor.remaining_hours = all_remaining_hours(leaves_for_work_package(ancestor)).sum.to_f
      ancestor.remaining_hours = nil if ancestor.remaining_hours == 0.0
    end

    def all_remaining_hours(work_packages)
      work_packages.map(&:remaining_hours).reject { |hours| hours.to_f.zero? }
    end

    def attributes_justify_inheritance?(attributes)
      super || attributes.include?(:remaining_hours)
    end

    def selected_leaves_attributes
      super + [:remaining_hours]
    end
  end
end
