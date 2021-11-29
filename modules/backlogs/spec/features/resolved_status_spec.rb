

require 'spec_helper'

describe 'Resolved status',
         type: :feature do
  let!(:project) do
    FactoryBot.create(:project,
                      enabled_module_names: %w(backlogs))
  end
  let!(:status) { FactoryBot.create(:status, is_default: true) }
  let(:role) do
    FactoryBot.create(:role,
                      permissions: %i[select_done_statuses])
  end
  let!(:current_user) do
    FactoryBot.create(:user,
                      member_in_project: project,
                      member_through_role: role)
  end
  let(:settings_page) { Pages::Projects::Settings.new(project) }

  before do
    login_as current_user
  end

  it 'allows setting a status as done although it is not closed' do
    settings_page.visit_tab! 'backlogs'

    check status.name
    click_button 'Save'

    settings_page.expect_toast(message: 'Successful update')

    expect(page)
      .to have_checked_field(status.name)
  end
end
