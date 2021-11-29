

require 'spec_helper'

describe 'work package hierarchies for milestones', js: true, selenium: true do
  let(:user) { FactoryBot.create :admin }
  let(:type) { FactoryBot.create(:type, is_milestone: true) }
  let(:project) { FactoryBot.create(:project, types: [type]) }
  let(:work_package) { FactoryBot.create(:work_package, project: project, type: type) }
  let(:relations) { ::Components::WorkPackages::Relations.new(work_package) }
  let(:tabs) { ::Components::WorkPackages::Tabs.new(work_package) }
  let(:wp_page) { Pages::FullWorkPackage.new(work_package) }

  let(:relations_tab) { find('.op-tab-row--link_selected', text: 'RELATIONS') }
  let(:visit) { true }

  before do
    login_as user
    wp_page.visit_tab!('relations')
    expect_angular_frontend_initialized
    wp_page.expect_subject
    loading_indicator_saveguard
  end

  it 'does not provide links to add children or existing children (Regression #28745)' do
    within('.wp-relations--children') do
      expect(page).to have_no_text('Add existing child')
      expect(page).to have_no_text('Create new child')
      expect(page).to have_no_selector('wp-inline-create--add-link')
    end
  end
end
