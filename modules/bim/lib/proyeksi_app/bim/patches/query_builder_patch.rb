

module ProyeksiApp::Bim::Patches::QueryBuilderPatch
  def self.included(base) # :nodoc:
    base.prepend InstanceMethods
  end

  module InstanceMethods
    private

    def filters
      filters = super
      set_bcf_issue_associated_filter!(filters)

      filters
    end

    def set_bcf_issue_associated_filter!(filters)
      if value = config[:bcf_issue_associated].presence
        filters[:bcf_issue_associated] = {
          operator: "=",
          values: [value ? 't' : 'f']
        }
      end
    end
  end
end
