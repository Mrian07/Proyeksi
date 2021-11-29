

require 'support/pages/work_packages/abstract_work_package'

module Pages
  class FullWorkPackage < Pages::AbstractWorkPackage
    private

    def container
      find('.work-packages--show-view')
    end

    def path(tab = 'activity')
      if project
        project_work_package_path(project, work_package.id, tab)
      else
        work_package_path(work_package.id, tab)
      end
    end

    def create_page(args)
      Pages::FullWorkPackageCreate.new(args)
    end
  end
end
