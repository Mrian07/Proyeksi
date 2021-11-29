

require 'spec_helper'

require_relative '../support/pages/ifc_models/show'
require_relative '../support/pages/ifc_models/show_default'

describe 'BIM filter spec',
         with_config: { edition: 'bim' },
         type: :feature,
         js: true do
  let(:project) { FactoryBot.create :project, enabled_module_names: %w(bim work_package_tracking) }
  let(:open_status) { FactoryBot.create(:status, is_closed: false) }
  let(:closed_status) { FactoryBot.create(:status, is_closed: true) }

  let(:wp1) { FactoryBot.create(:work_package, project: project, status: open_status) }
  let(:wp2) { FactoryBot.create(:work_package, project: project, status: closed_status) }

  let(:admin) { FactoryBot.create :admin }

  let!(:model) do
    FactoryBot.create(:ifc_model_minimal_converted,
                      project: project,
                      uploader: admin)
  end

  let(:card_view) { ::Pages::WorkPackageCards.new(project) }
  let(:filters) { ::Components::WorkPackages::Filters.new }
  let(:model_page) { ::Pages::IfcModels::ShowDefault.new project }

  before do
    wp1
    wp2

    login_as(admin)
    model_page.visit!
    model_page.finished_loading
  end

  context 'on default page' do
    before do
      # Per default all open work packages are shown
      filters.expect_loaded
      filters.expect_filter_count 1
      filters.open
      filters.expect_filter_by('Status', 'open', nil)

      card_view.expect_work_package_listed wp1
      card_view.expect_work_package_not_listed wp2
    end

    it 'shows a filter button when there is a list shown' do
      model_page.page_shows_a_filter_button true

      model_page.switch_view 'Viewer'
      model_page.page_shows_a_filter_button false
    end

    it 'the filter is applied even after browser back' do
      # Change filter
      filters.set_operator('Status', 'closed', nil)
      filters.expect_filter_count 1

      card_view.expect_work_package_listed wp2
      card_view.expect_work_package_not_listed wp1

      # Using the browser back will reload the filter and the work packages
      page.go_back
      loading_indicator_saveguard

      filters.expect_loaded
      filters.expect_filter_count 1
      filters.expect_filter_by('Status', 'open', nil)

      card_view.expect_work_package_listed wp1
      card_view.expect_work_package_not_listed wp2
    end

    it 'the filter is applied even after reload' do
      # Change filter
      filters.set_operator('Status', 'closed', nil)
      filters.expect_filter_count 1

      card_view.expect_work_package_listed wp2
      card_view.expect_work_package_not_listed wp1

      # Reload and the filter is still correctly applied
      page.driver.browser.navigate.refresh

      filters.expect_loaded
      filters.expect_filter_count 1
      filters.open
      filters.expect_filter_by('Status', 'closed', nil)

      card_view.expect_work_package_listed wp2
      card_view.expect_work_package_not_listed wp1
    end
  end
end
