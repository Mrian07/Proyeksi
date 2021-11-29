

require 'spec_helper'

describe 'Meetings locking', type: :feature, js: true do
  let(:project) { FactoryBot.create :project, enabled_module_names: %w[meetings] }
  let(:user) { FactoryBot.create :admin }
  let!(:meeting) { FactoryBot.create :meeting }
  let!(:agenda) { FactoryBot.create :meeting_agenda, meeting: meeting }

  before do
    login_as(user)

    visit meeting_path(meeting)
  end

  it 'shows an error when trying to update a meeting update while editing' do
    # Edit agenda
    within '#tab-content-agenda' do
      find('.button--edit-agenda').click

      SeleniumHubWaiter.wait
      agenda.text = 'blabla'
      agenda.save!

      click_on 'Save'
    end

    expect(page).to have_text 'Information has been updated by at least one other user in the meantime.'
    expect(page).to have_selector '#edit-meeting_agenda'
  end
end
