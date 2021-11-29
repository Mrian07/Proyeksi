

require 'spec_helper'
require 'features/work_packages/work_packages_page'

describe 'Work package table refreshing due to split view', js: true do
  let(:project) { FactoryBot.create :project_with_types }
  let!(:work_package) { FactoryBot.create :work_package, project: project }
  let(:wp_split) { ::Pages::SplitWorkPackage.new work_package }
  let(:wp_table) { ::Pages::WorkPackagesTable.new project }
  let(:user) { FactoryBot.create :admin }

  before do
    login_as(user)
    wp_split.visit!
  end

  it 'toggles the watch state' do
    wp_split.ensure_page_loaded
    wp_split.edit_field(:subject).expect_text work_package.subject

    wp_table.expect_work_package_listed work_package
    page.within wp_table.row(work_package) do
      expect(page).to have_selector('.wp-table--drag-and-drop-handle.icon-drag-handle', visible: :all)
    end
  end
end
