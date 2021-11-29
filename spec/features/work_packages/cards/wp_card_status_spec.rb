

require 'spec_helper'

describe 'Update status from WP card', type: :feature, js: true do
  let(:manager_role) do
    FactoryBot.create :role, permissions: %i[view_work_packages edit_work_packages]
  end
  let(:manager) do
    FactoryBot.create :user,
                      firstname: 'Manager',
                      lastname: 'Guy',
                      member_in_project: project,
                      member_through_role: manager_role
  end
  let(:status1) { FactoryBot.create :status }
  let(:status2) { FactoryBot.create :status }

  let(:type) { FactoryBot.create :type }
  let!(:project) { FactoryBot.create(:project, types: [type]) }
  let!(:work_package) do
    FactoryBot.create(:work_package,
                      project: project,
                      type: type,
                      status: status1,
                      subject: 'Foobar')
  end

  let!(:workflow) do
    FactoryBot.create :workflow,
                      type_id: type.id,
                      old_status: status1,
                      new_status: status2,
                      role: manager_role
  end

  let(:wp_table) { ::Pages::WorkPackagesTable.new(project) }
  let(:wp_card_view) { ::Pages::WorkPackageCards.new(project) }
  let(:display_representation) { ::Components::WorkPackages::DisplayRepresentation.new }

  before do
    login_as(manager)

    wp_table.visit!
    wp_table.expect_work_package_listed(work_package)

    display_representation.switch_to_card_layout
  end

  it 'can update the status through the button' do
    status_button = wp_card_view.status_button(work_package)
    status_button.update status2.name

    wp_card_view.expect_and_dismiss_toaster message: 'Successful update.'
    status_button.expect_text status2.name

    work_package.reload
    expect(work_package.status).to eq(status2)
  end
end
