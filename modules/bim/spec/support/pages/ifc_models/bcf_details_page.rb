

require 'support/pages/work_packages/split_work_package'
require_relative '../../components/bcf_details_viewpoints'

module Pages
  class BcfDetailsPage < Pages::SplitWorkPackage
    include ::Components::BcfDetailsViewpoints

    protected

    def path(tab = 'overview')
      bcf_project_frontend_path project, "split/details/#{work_package.id}/#{tab}"
    end
  end
end
