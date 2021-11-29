

require 'support/pages/page'
require 'support/pages/work_packages/abstract_work_package_create'

module Pages
  class SplitWorkPackageCreate < AbstractWorkPackageCreate
    def initialize(project:, original_work_package: nil, parent_work_package: nil)
      super(original_work_package: original_work_package,
            parent_work_package: parent_work_package,
            project: project)
    end

    def container
      find('.work-packages--new')
    end

    private

    def path
      if original_work_package
        project_work_packages_path(project) + "/details/#{original_work_package.id}/copy"
      else
        path = project_work_packages_path(project) + '/create_new'
        path += "?parent_id=#{parent_work_package.id}" if parent_work_package

        path
      end
    end
  end
end
