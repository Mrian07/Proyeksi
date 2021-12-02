

require_dependency 'type'

module ProyeksiApp::Backlogs::Patches::TypePatch
  def self.included(base)
    base.class_eval do
      include InstanceMethods
      extend ClassMethods
    end
  end

  module ClassMethods
  end

  module InstanceMethods
    def story?
      Story.types.include?(id)
    end

    def task?
      Task.type.present? && id == Task.type
    end
  end
end
