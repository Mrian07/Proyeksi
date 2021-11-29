

require 'spec_helper'

describe 'Role creation', type: :feature, js: true do
  let!(:admin) { FactoryBot.create(:admin) }
  let!(:existing_role) { FactoryBot.create(:role) }
  let!(:existing_workflow) { FactoryBot.create(:workflow_with_default_status, role: existing_role, type: type) }
  let!(:type) { FactoryBot.create(:type) }
  let!(:non_member) do
    FactoryBot.create(:non_member, permissions: %i[view_work_packages view_wiki_pages])
  end

  before do
    login_as(admin)
  end

  it 'allows creating roles and handles errors' do
    visit roles_path

    within '.toolbar-item' do
      click_link 'Role'
    end

    SeleniumHubWaiter.wait
    fill_in 'Name', with: existing_role.name
    select existing_role.name, from: 'Copy workflow from'
    check 'Edit work packages'
    check 'Edit project'

    click_button 'Create'

    expect(page)
      .to have_selector('.errorExplanation', text: 'Name has already been taken')

    SeleniumHubWaiter.wait
    fill_in 'Name', with: 'New role name'

    # This will lead to an error as manage versions requires view versions
    check 'Manage members'

    click_button 'Create'

    expect(page)
      .to have_selector('.errorExplanation',
                        text: "Permissions need to also include 'View members' as 'Manage members' is selected.")

    SeleniumHubWaiter.wait
    check 'View members'
    select existing_role.name, from: 'Copy workflow from'

    click_button 'Create'

    expect(page)
      .to have_selector('.notice', text: 'Successful creation.')

    expect(page)
      .to have_current_path(roles_path)

    expect(page)
      .to have_selector('table td', text: 'New role name')

    SeleniumHubWaiter.wait
    click_link 'New role name'

    expect(page)
      .to have_checked_field('Edit work packages')
    expect(page)
      .to have_checked_field('Edit project')
    expect(page)
      .to have_checked_field('Manage members')
    expect(page)
      .to have_checked_field('View members')

    # By default as Non Member has that permissions
    expect(page)
      .to have_checked_field('View work packages')
    expect(page)
      .to have_checked_field('View wiki')

    expect(page)
      .to have_unchecked_field('Select types')
    expect(page)
      .to have_unchecked_field('Delete watchers')

    # Workflow should be copied over.
    # Workflow routes are not resource-oriented.
    visit(url_for(controller: :workflows, action: :edit, only_path: true))

    SeleniumHubWaiter.wait
    select 'New role name', from: 'Role'
    select type.name, from: 'Type'
    click_button 'Edit'

    from_id = existing_workflow.old_status_id
    to_id = existing_workflow.new_status_id

    expect(page).to have_field("status_#{from_id}_#{to_id}_", checked: true)
  end
end
