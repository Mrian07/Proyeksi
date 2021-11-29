

require 'spec_helper'

describe 'Meetings close', type: :feature do
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
  let!(:meeting_agenda) { FactoryBot.create :meeting_agenda, meeting: meeting, text: "asdf" }

  before do
    login_as(user)
  end

  context 'with permission to close meetings', js: true do
    let(:permissions) { %i[view_meetings close_meeting_agendas] }

    it 'can delete own and other`s meetings' do
      visit meetings_path(project)

      click_link meeting.title

      # Go to minutes, expect uneditable
      SeleniumHubWaiter.wait
      find('.op-tab-row--link', text: 'MINUTES').click

      expect(page).to have_selector('.button', text: 'Close the agenda to begin the Minutes')

      # Close the meeting
      SeleniumHubWaiter.wait
      find('.op-tab-row--link', text: 'AGENDA').click
      SeleniumHubWaiter.wait
      find('.button', text: 'Close').click
      page.accept_confirm

      # Expect to be on minutes
      expect(page).to have_selector('.op-tab-row--link_selected', text: 'MINUTES')

      # Copies the text
      expect(page).to have_selector('#meeting_minutes-text', text: 'asdf')

      # Go back to agenda, expect we can open it again
      SeleniumHubWaiter.wait
      find('.op-tab-row--link', text: 'AGENDA').click
      SeleniumHubWaiter.wait
      find('.button', text: 'Open').click
      page.accept_confirm
      expect(page).to have_selector('.button', text: 'Close')
    end
  end

  context 'without permission to close meetings' do
    let(:permissions) { %i[view_meetings] }

    it 'cannot delete own and other`s meetings' do
      visit meetings_path(project)

      expect(page)
        .to have_no_link 'Close'
    end
  end
end
