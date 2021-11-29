

require 'spec_helper'

describe 'Meetings', type: :feature, js: true do
  let(:project) { FactoryBot.create :project, enabled_module_names: %w[meetings activity] }
  let(:user) { FactoryBot.create(:admin) }

  let!(:meeting) { FactoryBot.create :meeting, project: project, title: 'Awesome meeting!' }
  let!(:agenda) { FactoryBot.create :meeting_agenda, meeting: meeting, text: 'foo' }
  let!(:minutes) { FactoryBot.create :meeting_minutes, meeting: meeting, text: 'minutes' }

  before do
    login_as(user)
  end

  describe 'project activity' do
    it 'can show the meeting in the project activity' do
      visit project_activity_index_path(project)

      check 'Meetings'
      click_on 'Apply'

      expect(page).to have_selector('li.meeting', text: 'Awesome meeting!')
      expect(page).to have_selector('.meeting-agenda', text: 'Agenda: Awesome meeting!')
    end
  end
end
