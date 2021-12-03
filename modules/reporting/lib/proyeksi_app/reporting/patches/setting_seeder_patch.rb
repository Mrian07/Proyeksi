

module ProyeksiApp::Reporting::Patches::SettingSeederPatch
  def self.included(base) # :nodoc:
    base.prepend InstanceMethods
  end

  module InstanceMethods
    def data
      original_data = super

      unless original_data['default_projects_modules'].include? 'reporting_module'
        original_data['default_projects_modules'] << 'reporting_module'
      end

      original_data
    end
  end
end
