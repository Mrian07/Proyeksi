

require 'spec_helper'

describe 'Read-only statuses affect work package editing',
         with_ee: %i[readonly_work_packages],
         type: :feature,
         js: true do
  let(:locked_status) { FactoryBot.create :status, name: 'Locked', is_readonly: true }
  let(:unlocked_status) { FactoryBot.create :status, name: 'Unlocked', is_readonly: false }

  let(:type) { FactoryBot.create :type_bug }
  let(:project) { FactoryBot.create :project, types: [type] }
  let!(:work_package) do
    FactoryBot.create :work_package,
                      project: project,
                      type: type,
                      status: unlocked_status
  end

  let(:role) { FactoryBot.create :role, permissions: %i[edit_work_packages view_work_packages] }
  let(:user) do
    FactoryBot.create :user,
                      member_in_project: project,
                      member_through_role: role
  end

  let!(:workflow1) do
    FactoryBot.create :workflow,
                      type_id: type.id,
                      old_status: unlocked_status,
                      new_status: locked_status,
                      role: role
  end
  let!(:workflow2) do
    FactoryBot.create :workflow,
                      type_id: type.id,
                      old_status: locked_status,
                      new_status: unlocked_status,
                      role: role
  end

  let(:wp_page) { Pages::FullWorkPackage.new(work_package) }

  before do
    login_as(user)
    wp_page.visit!
  end

  it 'locks the work package on a read only status' do
    expect(page).to have_selector '.work-package--attachments--drop-box'

    subject_field = wp_page.edit_field :subject
    subject_field.activate!
    subject_field.cancel_by_escape

    status_field = wp_page.edit_field :status
    status_field.expect_state_text 'Unlocked'
    status_field.update 'Locked'

    wp_page.expect_and_dismiss_toaster(message: 'Successful update.')

    status_field.expect_state_text 'Locked'

    subject_field = wp_page.edit_field :subject
    subject_field.activate! expect_open: false
    subject_field.expect_read_only

    # Expect attachments not available
    expect(page).to have_no_selector '.work-package--attachments--drop-box'
  end
end
