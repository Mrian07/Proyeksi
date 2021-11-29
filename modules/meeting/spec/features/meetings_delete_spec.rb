

require 'spec_helper'

describe 'Meetings deletion', type: :feature do
  let(:project) { FactoryBot.create :project, enabled_module_names: %w[meetings] }
  let(:user) do
    FactoryBot.create(:user,
                      member_in_project: project,
                      member_with_permissions: permissions)
  end
  let(:other_user) do
    FactoryBot.create(:user,
                      member_in_project: project,
                      member_with_permissions: permissions)
  end

  let!(:meeting) { FactoryBot.create :meeting, project: project, title: 'Own awesome meeting!', author: user }
  let!(:other_meeting) { FactoryBot.create :meeting, project: project, title: 'Other awesome meeting!', author: other_user }

  before do
    login_as(user)
  end

  context 'with permission to delete meetings', js: true do
    let(:permissions) { %i[view_meetings delete_meetings] }

    it 'can delete own and other`s meetings' do
      visit meetings_path(project)

      SeleniumHubWaiter.wait
      click_link meeting.title
      SeleniumHubWaiter.wait
      click_link "Delete"

      page.accept_confirm

      expect(page)
        .to have_current_path meetings_path(project)

      SeleniumHubWaiter.wait
      click_link other_meeting.title
      SeleniumHubWaiter.wait
      click_link "Delete"

      page.accept_confirm

      expect(page)
        .to have_content(I18n.t('.no_results_title_text', cascade: true))

      expect(current_path)
        .to eql meetings_path(project)
    end
  end

  context 'without permission to delete meetings' do
    let(:permissions) { %i[view_meetings] }

    it 'cannot delete own and other`s meetings' do
      visit meetings_path(project)

      click_link meeting.title
      expect(page)
        .to have_no_link 'Delete'

      visit meetings_path(project)

      click_link other_meeting.title
      expect(page)
        .to have_no_link 'Delete'
    end
  end
end
