

require 'spec_helper'
require_relative './support/board_index_page'
require_relative './support/board_page'

describe 'Work Package boards updating spec', type: :feature, js: true do
  let(:admin) { FactoryBot.create(:admin) }

  let(:project) { FactoryBot.create(:project, enabled_module_names: %i[work_package_tracking board_view]) }
  let!(:priority) { FactoryBot.create :default_priority }
  let!(:status) { FactoryBot.create :default_status }

  let(:board_index) { Pages::BoardIndex.new(project) }
  let!(:board_view) { FactoryBot.create :board_grid_with_query, name: 'My board', project: project }

  before do
    with_enterprise_token :board_view
    project
    login_as(admin)
    board_index.visit!
  end

  it 'Changing the title in the split screen, updates the card automatically' do
    board_page = board_index.open_board board_view
    board_page.expect_query 'List 1', editable: true
    board_page.add_card 'List 1', 'Foo Bar'
    board_page.expect_toast message: I18n.t(:notice_successful_create)

    work_package = WorkPackage.last
    expect(work_package.subject).to eq 'Foo Bar'

    # Open in split view
    card = board_page.card_for(work_package)
    split_view = card.open_details_view
    split_view.expect_subject
    split_view.edit_field(:subject).update('My super cool new title')

    split_view.expect_and_dismiss_toaster message: 'Successful update.'
    card.expect_subject 'My super cool new title'
  end
end
