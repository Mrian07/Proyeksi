

require 'spec_helper'

describe 'Work package attribute help texts', type: :feature, js: true do
  let(:project) { FactoryBot.create :project }
  let(:work_package) { FactoryBot.create :work_package, project: project }

  let(:instance) do
    FactoryBot.create :work_package_help_text,
                      attribute_name: :status,
                      help_text: 'Some **help text** for status.'
  end

  let(:modal) { Components::AttributeHelpTextModal.new(instance) }
  let(:wp_page) { Pages::FullWorkPackage.new work_package }

  before do
    work_package
    instance
    login_as(user)

    wp_page.visit!
    wp_page.ensure_page_loaded
  end

  shared_examples 'allows to view help texts' do
    it 'shows an indicator for whatever help text exists' do
      expect(page).to have_selector('.work-package--single-view [data-qa-help-text-for="status"]')

      # Open help text modal
      modal.open!
      expect(modal.modal_container).to have_selector('strong', text: 'help text')
      modal.expect_edit(admin: user.admin?)

      modal.close!
    end
  end

  describe 'as admin' do
    let(:user) { FactoryBot.create(:admin) }
    it_behaves_like 'allows to view help texts'
  end

  describe 'as regular user' do
    let(:view_wps_role) do
      FactoryBot.create :role, permissions: [:view_work_packages]
    end
    let(:user) do
      FactoryBot.create :user,
                        member_in_project: project,
                        member_through_role: view_wps_role
    end

    it_behaves_like 'allows to view help texts'
  end
end
