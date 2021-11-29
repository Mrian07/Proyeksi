

require 'support/pages/page'
require_relative '../bcf/create_split'

module Pages
  module IfcModels
    class ShowDefault < ::Pages::WorkPackageCards
      include ::Pages::WorkPackages::Concerns::WorkPackageByButtonCreator

      attr_accessor :project

      def initialize(project)
        self.project = project
      end

      def path
        defaults_bcf_project_ifc_models_path(project)
      end

      def visit_and_wait_until_finished_loading!
        visit!
        finished_loading
      end

      def finished_loading
        expect(page).to have_selector('.xeokit-busy-modal', visible: false, wait: 30)
      end

      def model_viewer_visible(visible)
        # Ensure the canvas is present
        canvas_selector = '.op-ifc-viewer--model-canvas'
        expect(page).to(visible ? have_selector(canvas_selector, wait: 10) : have_no_selector(canvas_selector, wait: 10))
        # Ensure Xeokit is initialized. Only then the toolbar is generated.
        toolbar_selector = '.xeokit-toolbar'
        expect(page).to(visible ? have_selector(toolbar_selector, wait: 10) : have_no_selector(toolbar_selector, wait: 10))
      end

      def model_viewer_shows_a_toolbar(visible)
        selector = '.xeokit-btn'

        if visible
          within('[data-qa-selector="op-ifc-viewer--toolbar-container"]') do
            expect(page).to have_selector(selector, count: 8)
          end
        else
          expect(page).to have_no_selector(selector)
          expect(page).to have_no_selector('[data-qa-selector="op-ifc-viewer--toolbar-container"]')
        end
      end

      def page_shows_a_toolbar(visible)
        toolbar_items.each do |button|
          expect(page).to have_conditional_selector(visible, '.toolbar-item', text: button)
        end
      end

      def page_has_a_toolbar
        expect(page).to have_selector('.toolbar-container')
      end

      def page_shows_a_filter_button(visible)
        expect(page).to have_conditional_selector(visible, '.toolbar-item', text: 'Filter')
      end

      def page_shows_a_refresh_button(visible)
        expect(page).to have_conditional_selector(visible, '.toolbar-item a.refresh-button')
      end

      def click_refresh_button
        page.find('.toolbar-item a.refresh-button').click
      end

      def switch_view(value)
        page.find('#bim-view-toggle-button').click
        within('#bim-view-context-menu') do
          page.find('.menu-item', text: value, exact_text: true).click
        end
      end

      def expect_view_toggle_at(value)
        expect(page).to have_selector('#bim-view-toggle-button', text: value)
      end

      def has_no_menu_item_with_text?(value)
        expect(page).to have_no_selector('.menu-item', text: value)
      end

      private

      def toolbar_items
        ['IFC models']
      end

      def create_page_class_instance(type)
        create_page_class.new(project: project, type_id: type.id)
      end

      def create_page_class
        Pages::BCF::CreateSplit
      end
    end
  end
end
