

module OpenProject::Bim::Patches::API::V3::WorkPackages::EagerLoading::ChecksumPatch
  def self.included(base)
    class << base
      prepend ClassMethods
    end
  end

  module ClassMethods
    protected

    def checksum_associations
      super + %i[bcf_issue]
    end
  end
end
