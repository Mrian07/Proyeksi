

require 'spec_helper'
require_relative './../support//board_index_page'
require_relative './../support/board_page'

describe 'Custom field filter in boards', type: :feature, js: true do
  let(:user) do
    FactoryBot.create(:user,
                      member_in_project: project,
                      member_through_role: role)
  end
  let(:type) { FactoryBot.create(:type_standard) }
  let(:project) { FactoryBot.create(:project, types: [type], enabled_module_names: %i[work_package_tracking board_view]) }
  let(:role) { FactoryBot.create(:role, permissions: permissions) }

  let(:board_index) { Pages::BoardIndex.new(project) }

  let(:permissions) do
    %i[show_board_views manage_board_views add_work_packages
       edit_work_packages view_work_packages manage_public_queries]
  end

  let!(:priority) { FactoryBot.create :default_priority }
  let!(:open_status) { FactoryBot.create :default_status, name: 'Open' }
  let!(:closed_status) { FactoryBot.create :status, is_closed: true, name: 'Closed' }

  let!(:work_package) do
    wp = FactoryBot.build :work_package,
                          project: project,
                          type: type,
                          subject: 'Foo',
                          status: open_status

    wp.custom_field_values = {
      custom_field.id => %w[B].map { |s| custom_value_for(s) }
    }

    wp.save
    wp
  end

  let(:filters) { ::Components::WorkPackages::Filters.new }

  let(:custom_field) do
    FactoryBot.create(
      :list_wp_custom_field,
      name: "Ingredients",
      multi_value: true,
      types: [type],
      projects: [project],
      possible_values: %w[A B C]
    )
  end

  def custom_value_for(str)
    custom_field.custom_options.find { |co| co.value == str }.try(:id)
  end

  before do
    with_enterprise_token :board_view
    project
    login_as(user)
  end

  it 'can add a case-insensitive list (Regression #35744)' do
    board_index.visit!

    # Create new board
    board_page = board_index.create_board action: :Status

    # expect lists of default status
    board_page.expect_list 'Open'

    # Add a filter for CF value A and B
    filters.expect_filter_count 0
    filters.open

    filters.add_filter_by(custom_field.name,
                          'is',
                          ['A', 'B'],
                          "customField#{custom_field.id}")

    board_page.expect_changed

    # Save that filter
    board_page.save

    board_page.add_list option: 'Closed', query: 'closed'
    board_page.expect_list 'Closed'

    # Expect card to be present
    board_page.expect_card('Open', 'Foo', present: true)

    # Move card to list closed
    board_page.move_card(0, from: 'Open', to: 'Closed')

    board_page.expect_card('Closed', 'Foo', present: true)
    board_page.expect_card('Open', 'Foo', present: false)

    # Expect custom field to be unchanged
    work_package.reload
    cv = work_package.custom_value_for(custom_field).typed_value
    expect(cv).to eq 'B'
  end
end
