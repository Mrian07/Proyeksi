

module OpenProject::Backlogs::Patches::SettingSeederPatch
  def self.included(base) # :nodoc:
    base.prepend InstanceMethods
  end

  module InstanceMethods
    ##
    # Overrides data to include backlogs as a default project module.
    def data
      original_data = super

      unless original_data['default_projects_modules'].include? 'backlogs'
        original_data['default_projects_modules'] << 'backlogs'
      end

      original_data
    end
  end
end
