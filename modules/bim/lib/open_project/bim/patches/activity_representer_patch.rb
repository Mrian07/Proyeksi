

module OpenProject::Bim::Patches::ActivityRepresenterPatch
  def self.included(base) # :nodoc:
    base.prepend InstanceMethods
  end

  module InstanceMethods
    def _type
      if represented.bcf_comment.present?
        'Activity::BcfComment'
      else
        super
      end
    end
  end
end
