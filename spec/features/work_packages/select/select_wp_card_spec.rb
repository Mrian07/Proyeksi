

require 'spec_helper'

describe 'Select work package card', type: :feature, js: true, selenium: true do
  let(:user) { FactoryBot.create(:admin) }
  let(:project) { FactoryBot.create(:project) }
  let(:work_package_1) { FactoryBot.create(:work_package, project: project) }
  let(:work_package_2) { FactoryBot.create(:work_package, project: project) }
  let(:wp_table) { ::Pages::WorkPackagesTable.new(project) }
  let(:wp_card_view) { ::Pages::WorkPackageCards.new(project) }

  let(:display_representation) { ::Components::WorkPackages::DisplayRepresentation.new }

  before do
    login_as(user)

    work_package_1
    work_package_2

    wp_table.visit!
    wp_table.expect_work_package_listed(work_package_1)
    wp_table.expect_work_package_listed(work_package_2)

    display_representation.switch_to_card_layout
  end

  describe 'opening' do
    it 'the full screen view via double click' do
      wp_card_view.open_full_screen_by_doubleclick(work_package_1)
      expect(page).to have_selector('.work-packages--details--subject',
                                    text: work_package_1.subject)
    end

    it 'the split screen of the selected WP' do
      wp_card_view.select_work_package(work_package_2)
      find('#work-packages-details-view-button').click
      split_wp = Pages::SplitWorkPackage.new(work_package_2)
      split_wp.expect_attributes Subject: work_package_2.subject

      find('#work-packages-details-view-button').click
      expect(page).to have_no_selector('.work-packages--details')
    end
  end
end
