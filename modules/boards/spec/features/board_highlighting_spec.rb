

require 'spec_helper'
require_relative './support/board_index_page'
require_relative './support/board_page'

describe 'Work Package boards spec', type: :feature, js: true do
  let(:user) do
    FactoryBot.create(:user,
                      member_in_project: project,
                      member_through_role: role)
  end
  let(:project) { FactoryBot.create(:project, enabled_module_names: %i[work_package_tracking board_view]) }
  let(:permissions) { %i[show_board_views manage_board_views add_work_packages view_work_packages manage_public_queries] }
  let(:role) { FactoryBot.create(:role, permissions: permissions) }

  let!(:wp) do
    FactoryBot.create(:work_package,
                      project: project,
                      type: type,
                      priority: priority,
                      status: open_status)
  end
  let!(:wp2) do
    FactoryBot.create(:work_package,
                      project: project,
                      type: type2,
                      priority: priority2,
                      status: open_status)
  end

  let!(:priority) { FactoryBot.create :priority, color: color }
  let!(:priority2) { FactoryBot.create :priority, color: color2 }
  let!(:type) { FactoryBot.create :type, color: color }
  let!(:type2) { FactoryBot.create :type, color: color2 }
  let!(:open_status) { FactoryBot.create :default_status, name: 'Open' }

  let(:board_index) { Pages::BoardIndex.new(project) }

  let(:color) { FactoryBot.create :color }
  let(:color2) { FactoryBot.create :color }

  before do
    with_enterprise_token :board_view
    project
    login_as(user)
  end

  it 'navigates from boards to the WP full view and back' do
    board_index.visit!

    board_page = board_index.create_board action: :Status

    # See the work packages
    board_page.expect_query 'Open', editable: false
    board_page.expect_card 'Open', wp.subject
    board_page.expect_card 'Open', wp2.subject

    # Highlight type inline is always active
    expect(page).to have_selector('.__hl_inline_type_' + type.id.to_s)
    expect(page).to have_selector('.__hl_inline_type_' + type2.id.to_s)

    # Highlight whole card by priority
    board_page.change_board_highlighting 'inline', 'Priority'
    expect(page).to have_selector('.__hl_background_priority_' + priority.id.to_s)
    expect(page).to have_selector('.__hl_background_priority_' + priority2.id.to_s)

    # Highlight whole card by type
    board_page.change_board_highlighting 'inline', 'Type'
    expect(page).to have_selector('.__hl_background_type_' + type.id.to_s)
    expect(page).to have_selector('.__hl_background_type_' + type2.id.to_s)

    # Disable highlighting
    board_page.change_board_highlighting 'none'
    expect(page).not_to have_selector('.__hl_background_type_' + type.id.to_s)
    expect(page).not_to have_selector('.__hl_background_type_' + type2.id.to_s)

    # Type is still shown highlighted
    expect(page).to have_selector('.__hl_inline_type_' + type.id.to_s)
    expect(page).to have_selector('.__hl_inline_type_' + type2.id.to_s)
  end
end
