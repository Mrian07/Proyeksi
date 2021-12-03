

module ProyeksiApp::Meeting::Patches::SettingSeederPatch
  def self.included(base) # :nodoc:
    base.prepend InstanceMethods
  end

  module InstanceMethods
    def data
      original_data = super

      unless original_data['default_projects_modules'].include? 'meetings'
        original_data['default_projects_modules'] << 'meetings'
      end

      original_data
    end
  end
end
