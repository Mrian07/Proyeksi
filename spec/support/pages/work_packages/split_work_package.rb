

require 'support/pages/work_packages/abstract_work_package'
require 'support/pages/work_packages/split_work_package_create'

module Pages
  class SplitWorkPackage < Pages::AbstractWorkPackage
    attr_reader :selector

    def initialize(work_package, project = nil)
      super work_package, project
      @selector = '.work-packages--details'
    end

    def switch_to_fullscreen
      find('.work-packages--details-fullscreen-icon').click
      FullWorkPackage.new(work_package, project)
    end

    def expect_closed
      expect(page).to have_no_selector(@selector)
    end

    def expect_open
      expect(page).to have_selector(@selector)
      expect_subject
    end

    def close
      find('.work-packages--details-close-icon').click
    end

    def container
      find(@selector)
    end

    protected

    def path(tab = 'overview')
      state = "#{work_package.id}/#{tab}"

      if project
        project_work_packages_path(project, "details/#{state}")
      else
        details_work_packages_path(state)
      end
    end

    def create_page(args)
      args.merge!(project: project || work_package.project)
      SplitWorkPackageCreate.new(args)
    end
  end
end
