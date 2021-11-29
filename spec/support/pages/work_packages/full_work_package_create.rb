

require 'support/pages/page'
require 'support/pages/work_packages/abstract_work_package_create'

module Pages
  class FullWorkPackageCreate < AbstractWorkPackageCreate
    private

    def container
      find('.work-packages--show-view')
    end

    def path
      if original_work_package
        project_work_package_path(original_work_package.project, original_work_package.id) + '/copy'
      elsif parent_work_package
        new_project_work_packages_path(parent_work_package.project.identifier,
                                       parent_id: parent_work_package.id)
      elsif project
        new_project_work_packages_path(project.identifier)
      end
    end
  end
end
