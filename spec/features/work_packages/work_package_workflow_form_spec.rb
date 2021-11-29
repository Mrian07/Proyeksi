#-- encoding: UTF-8



require 'spec_helper'
require 'features/page_objects/notification'

describe 'Work package transitive status workflows', js: true do
  let(:dev_role) do
    FactoryBot.create :role,
                      permissions: %i[view_work_packages
                                      edit_work_packages]
  end
  let(:dev) do
    FactoryBot.create :user,
                      firstname: 'Dev',
                      lastname: 'Guy',
                      member_in_project: project,
                      member_through_role: dev_role
  end

  let(:type) { FactoryBot.create :type }
  let(:project) { FactoryBot.create(:project, types: [type]) }

  let(:work_package) do
    work_package = FactoryBot.create :work_package,
                                     project: project,
                                     type: type,
                                     created_at: 5.days.ago.to_date.to_s(:db)

    note_journal = work_package.journals.last
    note_journal.update(created_at: 5.days.ago.to_date.to_s)

    work_package
  end
  let(:wp_page) { Pages::FullWorkPackage.new(work_package) }

  let(:status_from) { work_package.status }
  let(:status_intermediate) { FactoryBot.create :status }
  let(:status_to) { FactoryBot.create :status }

  let(:workflows) do
    FactoryBot.create :workflow,
                      type_id: type.id,
                      old_status: status_from,
                      new_status: status_intermediate,
                      role: dev_role

    FactoryBot.create :workflow,
                      type_id: type.id,
                      old_status: status_intermediate,
                      new_status: status_to,
                      role: dev_role
  end

  before do
    login_as(dev)

    work_package
    workflows

    wp_page.visit!
    wp_page.ensure_page_loaded
  end

  ##
  # Regression test for #24129
  it 'allows to move to the final status as defined in the workflow' do
    wp_page.update_attributes status: status_intermediate.name
    wp_page.expect_attributes status: status_intermediate.name

    wp_page.expect_activity_message "Status changed from #{status_from.name} " \
                                    "to #{status_intermediate.name}"

    wp_page.update_attributes status: status_to.name
    wp_page.expect_attributes status: status_to.name

    wp_page.expect_activity_message "Status changed from #{status_from.name} " \
                                    "to #{status_to.name}"

    work_package.reload
    expect(work_package.status).to eq(status_to)
  end
end
