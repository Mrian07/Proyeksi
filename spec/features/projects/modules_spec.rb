

require 'spec_helper'

describe 'Projects module administration',
         type: :feature do

  let!(:project) do
    FactoryBot.create(:project,
                      enabled_module_names: [])
  end

  let(:role) do
    FactoryBot.create(:role,
                      permissions: permissions)
  end
  let(:permissions) { %i(edit_project select_project_modules) }
  let(:settings_page) { Pages::Projects::Settings.new(project) }

  current_user do
    FactoryBot.create(:user,
                      member_in_project: project,
                      member_with_permissions: permissions)
  end

  it 'allows adding and removing modules' do
    settings_page.visit_tab!('modules')

    expect(page)
      .to have_unchecked_field 'Activity'

    expect(page)
      .to have_unchecked_field 'Calendar'

    expect(page)
      .to have_unchecked_field 'Time and costs'

    check 'Activity'

    click_button 'Save'

    settings_page.expect_toast message: I18n.t(:notice_successful_update)

    expect(page)
      .to have_checked_field 'Activity'

    expect(page)
      .to have_unchecked_field 'Calendar'

    expect(page)
      .to have_unchecked_field 'Time and costs'

    check 'Calendar'

    click_button 'Save'

    expect(page)
      .to have_selector '.op-toast.-error',
                        text: I18n.t(:'activerecord.errors.models.project.attributes.enabled_modules.dependency_missing',
                                     dependency: 'Work package tracking',
                                     module: 'Calendar')

    check 'Work package tracking'

    click_button 'Save'

    settings_page.expect_toast message: I18n.t(:notice_successful_update)

    expect(page)
      .to have_checked_field 'Activity'

    expect(page)
      .to have_checked_field 'Calendar'

    expect(page)
      .to have_checked_field 'Work package tracking'
  end

  context 'with a user who does not have the correct permissions (#38097)' do
    let(:user_without_permission) do
      FactoryBot.create(:user,
                        member_in_project: project,
                        member_with_permissions: %i(edit_project))
    end

    before do
      login_as user_without_permission
      settings_page.visit_tab!('general')
    end

    it "I can't see the modules menu item" do
      expect(page)
        .not_to have_selector('[data-name="settings_modules"]')
    end
  end
end
