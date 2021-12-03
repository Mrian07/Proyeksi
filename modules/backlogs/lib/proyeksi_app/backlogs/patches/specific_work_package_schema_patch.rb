

require_dependency 'api/v3/work_packages/schema/specific_work_package_schema'

module ProyeksiApp::Backlogs::Patches::SpecificWorkPackageSchemaPatch
  def self.included(base)
    base.class_eval do
      prepend InstanceMethods
      extend ClassMethods
    end
  end

  module ClassMethods
  end

  module InstanceMethods
    def writable?(property)
      if property == :remaining_time && !@work_package.leaf?
        false
      elsif version_with_backlogs_parent(property)
        false
      else
        super
      end
    end

    private

    def version_with_backlogs_parent(property)
      property == :version && @work_package.is_task? && WorkPackage.find(@work_package.parent_id).in_backlogs_type?
    end
  end
end
