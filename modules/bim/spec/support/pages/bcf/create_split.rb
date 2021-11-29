

require 'support/pages/page'
require 'support/pages/work_packages/abstract_work_package_create'
require_relative '../../components/bcf_details_viewpoints'

module Pages
  module BCF
    class CreateSplit < ::Pages::AbstractWorkPackageCreate
      include ::Components::BcfDetailsViewpoints

      attr_accessor :project,
                    :model_id,
                    :type_id,
                    :view_route

      def initialize(project:, model_id: nil, type_id: nil)
        super(project: project)
        self.model_id = model_id
        self.type_id = type_id
        self.view_route = :split
      end

      # Override delete viewpoint since we don't have confirm alert
      def delete_viewpoint_at_position(index)
        page.all('.icon-delete.ngx-gallery-icon-content')[index].click
      end

      def path
        bcf_project_frontend_path(project, "#{view_route}/create_new")
      end

      def expect_current_path
        expect(page)
          .to have_current_path(path, ignore_query: true)
      end

      def container
        find("wp-new-split-view")
      end

      private

      def default?
        model_id.nil?
      end
    end
  end
end
