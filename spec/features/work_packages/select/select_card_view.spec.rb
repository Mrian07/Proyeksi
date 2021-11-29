

require 'spec_helper'

describe 'Selecting cards in the card view (regression #31962)', js: true do
  let(:user) { FactoryBot.create(:admin) }
  let(:project) { FactoryBot.create(:project) }
  let(:wp_table) { Pages::WorkPackagesTable.new(project) }
  let(:cards) { ::Pages::WorkPackageCards.new(project) }
  let(:display_representation) { ::Components::WorkPackages::DisplayRepresentation.new }
  let(:work_package_1) { FactoryBot.create(:work_package, project: project) }
  let(:work_package_2) { FactoryBot.create(:work_package, project: project) }
  let(:work_package_3) { FactoryBot.create(:work_package, project: project) }

  before do
    work_package_1
    work_package_2
    work_package_3

    login_as(user)
    wp_table.visit!
    display_representation.switch_to_card_layout
    cards.expect_work_package_listed work_package_1, work_package_2, work_package_3
  end

  context 'selecting cards' do
    it 'can select and deselect all cards' do
      # Select all
      cards.select_all_work_packages
      cards.expect_work_package_selected work_package_1, true
      cards.expect_work_package_selected work_package_2, true
      cards.expect_work_package_selected work_package_3, true

      # Deselect all
      cards.deselect_all_work_packages
      cards.expect_work_package_selected work_package_1, false
      cards.expect_work_package_selected work_package_2, false
      cards.expect_work_package_selected work_package_3, false
    end

    it 'can select and deselect single cards' do
      # Select a card
      cards.select_work_package work_package_1
      cards.expect_work_package_selected work_package_1, true
      cards.expect_work_package_selected work_package_2, false
      cards.expect_work_package_selected work_package_3, false

      # Selecting another card changes the selection
      cards.select_work_package work_package_2
      cards.expect_work_package_selected work_package_1, false
      cards.expect_work_package_selected work_package_2, true
      cards.expect_work_package_selected work_package_3, false

      # Deselect a card
      cards.deselect_work_package work_package_2
      cards.expect_work_package_selected work_package_1, false
      cards.expect_work_package_selected work_package_2, false
      cards.expect_work_package_selected work_package_3, false
    end

    it 'can select and deselect range of cards' do
      # Select the first WP
      cards.select_work_package work_package_1
      cards.expect_work_package_selected work_package_1, true
      cards.expect_work_package_selected work_package_2, false
      cards.expect_work_package_selected work_package_3, false

      # Select the third with Shift results in all WPs being selected
      cards.select_work_package_with_shift work_package_3
      cards.expect_work_package_selected work_package_1, true
      cards.expect_work_package_selected work_package_2, true
      cards.expect_work_package_selected work_package_3, true

      # The range can be changed
      cards.select_work_package_with_shift work_package_2
      cards.expect_work_package_selected work_package_1, true
      cards.expect_work_package_selected work_package_2, true
      cards.expect_work_package_selected work_package_3, false
    end
  end
end
