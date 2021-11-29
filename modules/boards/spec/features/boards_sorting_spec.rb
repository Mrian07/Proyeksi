

require 'spec_helper'
require_relative './support/board_index_page'
require_relative './support/board_page'

describe 'Work Package boards sorting spec', type: :feature, js: true do
  let(:admin) { FactoryBot.create(:admin) }
  let(:project) { FactoryBot.create(:project, enabled_module_names: %i[work_package_tracking board_view]) }
  let(:board_index) { Pages::BoardIndex.new(project) }
  let!(:status) { FactoryBot.create :default_status }
  let(:version) { @version ||= FactoryBot.create(:version, project: project) }

  before do
    with_enterprise_token :board_view
    project
    login_as(admin)
    board_index.visit!
  end

  # By adding each board the sort of table will change
  # The currently added board should be at the top
  it 'sorts the boards grid and menu based on their names' do
    board_page = board_index.create_board action: nil
    board_page.back_to_index

    expect(page.first('[data-qa-selector="boards-table-column--name"]'))
      .to have_text('Unnamed board')
    expect(page.first('[data-qa-selector="boards-menu--item"]'))
      .to have_text('Unnamed board')

    board_page = board_index.create_board action: :Version, expect_empty: true
    board_page.back_to_index

    expect(page.first('[data-qa-selector="boards-table-column--name"]'))
      .to have_text('Action board (version)')
    expect(page.first('[data-qa-selector="boards-menu--item"]'))
      .to have_text('Action board (version)')

    board_page = board_index.create_board action: :Status
    board_page.back_to_index

    expect(page.first('[data-qa-selector="boards-table-column--name"]'))
      .to have_text('Action board (status)')
    expect(page.first('[data-qa-selector="boards-menu--item"]'))
      .to have_text('Action board (status)')
  end
end
