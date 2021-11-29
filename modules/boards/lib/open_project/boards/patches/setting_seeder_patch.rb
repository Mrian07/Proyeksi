

module OpenProject::Boards::Patches::SettingSeederPatch
  def self.included(base) # :nodoc:
    base.prepend InstanceMethods
  end

  module InstanceMethods
    def data
      original_data = super

      unless original_data['default_projects_modules'].include? 'board_view'
        original_data['default_projects_modules'] << 'board_view'
      end

      original_data
    end
  end
end
