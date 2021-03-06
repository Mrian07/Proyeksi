

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper.rb')

describe 'Deleting time entries', type: :feature, js: true do
  let(:project) { work_package.project }
  let(:user) do
    FactoryBot.create :user,
                      member_in_project: project,
                      member_through_role: role
  end
  let(:role) do
    FactoryBot.create :role,
                      permissions: %i[view_work_packages
                                      delete_work_packages
                                      edit_cost_entries
                                      view_cost_entries]
  end
  let(:work_package) { FactoryBot.create :work_package }
  let(:destroy_modal) { Components::WorkPackages::DestroyModal.new }
  let(:cost_type) do
    type = FactoryBot.create :cost_type, name: 'Translations'
    FactoryBot.create :cost_rate,
                      cost_type: type,
                      rate: 7.00
    type
  end
  let(:budget) do
    FactoryBot.create(:budget, project: project)
  end
  let(:other_work_package) { FactoryBot.create :work_package, project: project, budget: budget }
  let(:cost_entry) do
    FactoryBot.create :cost_entry,
                      work_package: work_package,
                      project: project,
                      units: 2.00,
                      cost_type: cost_type,
                      user: user
  end

  it 'allows to move the time entry to a different work package' do
    login_as(user)

    work_package
    other_work_package
    cost_entry

    wp_page = Pages::FullWorkPackage.new(work_package)
    wp_page.visit!

    SeleniumHubWaiter.wait
    find('#action-show-more-dropdown-menu').click

    click_link(I18n.t('js.button_delete'))

    destroy_modal.expect_listed(work_package)
    destroy_modal.confirm_deletion

    SeleniumHubWaiter.wait
    choose 'to_do_action_reassign'
    fill_in 'to_do_reassign_to_id', with: other_work_package.id

    click_button(I18n.t('button_delete'))

    table = Pages::WorkPackagesTable.new(project)
    table.expect_current_path

    other_wp_page = Pages::FullWorkPackage.new(other_work_package)
    other_wp_page.visit!

    wp_page.expect_attributes costs_by_type: '2 Translations'
  end
end
