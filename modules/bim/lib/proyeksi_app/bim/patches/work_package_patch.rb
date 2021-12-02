

require_dependency 'work_package'

module ProyeksiApp::Bim::Patches::WorkPackagePatch
  def self.included(base)
    base.class_eval do
      has_one :bcf_issue, class_name: '::Bim::Bcf::Issue', foreign_key: 'work_package_id'

      def bcf_issue?
        bcf_issue.present?
      end
    end
  end
end
