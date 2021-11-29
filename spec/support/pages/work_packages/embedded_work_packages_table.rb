

require 'support/pages/page'
require 'support/pages/work_packages/work_packages_table'
require 'support/components/ng_select_autocomplete_helpers'

module Pages
  class EmbeddedWorkPackagesTable < WorkPackagesTable
    include ::Components::NgSelectAutocompleteHelpers

    attr_reader :container

    def initialize(container, project = nil)
      super(project)
      @container = container
    end

    def table_container
      container.find('.work-package-table')
    end

    def click_reference_inline_create
      ##
      # When using the inline create on initial page load,
      # there is a delay on travis where inline create can be clicked.
      sleep 1
      container.find('.wp-inline-create--reference-link').click

      # Returns the autocomplete container
      container.find('[data-qa-selector="wp-relations-autocomplete"]')
    end

    def reference_work_package(work_package, query: work_package.subject)
      click_reference_inline_create

      autocomplete_container = container.find('[data-qa-selector="wp-relations-autocomplete"]')
      select_autocomplete autocomplete_container,
                          query: query,
                          results_selector: '.ng-dropdown-panel-items'

      expect_work_package_listed work_package
    end
  end
end
