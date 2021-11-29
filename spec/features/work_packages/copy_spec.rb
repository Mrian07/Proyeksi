

require 'spec_helper'

RSpec.feature 'Work package copy', js: true, selenium: true do
  let(:user) do
    FactoryBot.create(:user,
                      member_in_project: project,
                      member_through_role: create_role)
  end
  let(:work_flow) do
    FactoryBot.create(:workflow,
                      role: create_role,
                      type_id: original_work_package.type_id,
                      old_status: original_work_package.status,
                      new_status: FactoryBot.create(:status))
  end

  let(:create_role) do
    FactoryBot.create(:role,
                      permissions: %i[view_work_packages
                                      add_work_packages
                                      manage_work_package_relations
                                      edit_work_packages
                                      assign_versions])
  end
  let(:type) { FactoryBot.create(:type) }
  let(:project) { FactoryBot.create(:project, types: [type]) }
  let(:original_work_package) do
    FactoryBot.build(:work_package,
                     project: project,
                     assigned_to: assignee,
                     responsible: responsible,
                     version: version,
                     type: type,
                     author: author)
  end
  let(:role) { FactoryBot.build(:role, permissions: [:view_work_packages]) }
  let(:assignee) do
    FactoryBot.create(:user,
                     firstname: 'An',
                     lastname: 'assignee',
                     member_in_project: project,
                     member_through_role: role)
  end
  let(:responsible) do
    FactoryBot.create(:user,
                     firstname: 'The',
                     lastname: 'responsible',
                     member_in_project: project,
                     member_through_role: role)
  end
  let(:author) do
    FactoryBot.create(:user,
                     firstname: 'The',
                     lastname: 'author',
                     member_in_project: project,
                     member_through_role: role)
  end
  let(:version) do
    FactoryBot.build(:version,
                     project: project)
  end

  before do
    login_as(user)
    original_work_package.save!
    work_flow.save!
  end

  scenario 'on fullscreen page' do
    original_work_package_page = Pages::FullWorkPackage.new(original_work_package, project)
    to_copy_work_package_page = original_work_package_page.visit_copy!

    to_copy_work_package_page.expect_current_path
    to_copy_work_package_page.expect_fully_loaded

    to_copy_work_package_page.update_attributes Description: 'Copied WP Description'
    to_copy_work_package_page.save!

    expect(page).to have_selector('.op-toast--content',
                                  text: I18n.t('js.notice_successful_create'))

    copied_work_package = WorkPackage.order(created_at: 'desc').first

    expect(copied_work_package).to_not eql original_work_package

    work_package_page = Pages::FullWorkPackage.new(copied_work_package, project)

    work_package_page.ensure_page_loaded
    work_package_page.expect_attributes Subject: original_work_package.subject,
                                        Description: 'Copied WP Description',
                                        Version: original_work_package.version,
                                        Priority: original_work_package.priority,
                                        Assignee: original_work_package.assigned_to.name,
                                        Responsible: original_work_package.responsible.name

    work_package_page.expect_activity user, number: 1
    work_package_page.expect_current_path

    work_package_page.visit_tab! :relations
    expect_angular_frontend_initialized
    expect(page).to have_selector('.relation-group--header', text: 'RELATED TO', wait: 20)
    expect(page).to have_selector('.wp-relations--subject-field', text: original_work_package.subject)
  end

  describe 'when source work package has an attachment' do
    it 'still allows copying through menu (Regression #30518)' do
      wp_page = Pages::FullWorkPackage.new(original_work_package, project)
      wp_page.visit!
      wp_page.ensure_page_loaded

      # Go to add cost entry page
      find('#action-show-more-dropdown-menu .button').click
      find('.menu-item', text: 'Copy').click

      to_copy_work_package_page = Pages::FullWorkPackageCreate.new original_work_package: original_work_package
      to_copy_work_package_page.update_attributes Description: 'Copied WP Description'
      to_copy_work_package_page.save!

      to_copy_work_package_page.expect_and_dismiss_toaster message: I18n.t('js.notice_successful_create')
    end
  end

  scenario 'on split screen page' do
    original_work_package_page = Pages::SplitWorkPackage.new(original_work_package, project)
    to_copy_work_package_page = original_work_package_page.visit_copy!

    to_copy_work_package_page.expect_current_path
    to_copy_work_package_page.expect_fully_loaded

    to_copy_work_package_page.update_attributes Description: 'Copied WP Description'
    to_copy_work_package_page.save!

    expect(page).to have_selector('.op-toast--content',
                                  text: I18n.t('js.notice_successful_create'))

    copied_work_package = WorkPackage.order(created_at: 'desc').first

    expect(copied_work_package).to_not eql original_work_package

    work_package_page = Pages::SplitWorkPackage.new(copied_work_package, project)

    work_package_page.ensure_page_loaded
    work_package_page.expect_attributes Subject: original_work_package.subject,
                                        Description: 'Copied WP Description',
                                        Version: original_work_package.version,
                                        Priority: original_work_package.priority,
                                        Assignee: original_work_package.assigned_to,
                                        Responsible: original_work_package.responsible

    work_package_page.expect_activity user, number: 1
    work_package_page.expect_current_path

    work_package_page.visit_tab!('relations')
    expect_angular_frontend_initialized
    expect(page).to have_selector('.relation-group--header', text: 'RELATED TO', wait: 20)
    expect(page).to have_selector('.wp-relations--subject-field', text: original_work_package.subject)
  end
end
