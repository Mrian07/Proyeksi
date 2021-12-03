

module ProyeksiApp::Reporting::Patches::RoleSeederPatch
  def self.included(base) # :nodoc:
    base.prepend InstanceMethods
  end

  module InstanceMethods
    def seed_data!
      super.tap do |_|
        ProyeksiApp::Reporting::DefaultData.load!
      end
    end
  end
end
