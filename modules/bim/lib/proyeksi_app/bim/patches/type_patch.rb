

##
# We do not want the bcf_thumbnail to show up in the work package full view as we already have the BCF Viewpoint gallery
# there. To achieve that we need to change how the default form configuration is set up. The default simply shall not
# not include 'bcf_thumbnail'.
#
# The right thing would be to patch the concern Type::AttributeGroups, but somehow I wasn't able to figure out how to do it.
# Thus I am patching the including Class.
module ProyeksiApp::Bim::Patches::TypePatch
  def self.included(base) # :nodoc:
    base.prepend InstanceMethods
  end

  module InstanceMethods
    private

    def default_attribute?(active_cfs, key)
      super(active_cfs, key) && key != 'bcf_thumbnail'
    end
  end
end
