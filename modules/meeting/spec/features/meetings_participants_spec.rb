

require 'spec_helper'

require_relative '../support/pages/meetings/edit'

describe 'Meetings participants', type: :feature do
  let(:project) { FactoryBot.create :project, enabled_module_names: %w[meetings] }
  let!(:user) do
    FactoryBot.create(:user,
                      firstname: 'Current',
                      member_in_project: project,
                      member_with_permissions: %i[view_meetings edit_meetings])
  end
  let!(:viewer_user) do
    FactoryBot.create(:user,
                      firstname: 'Viewer',
                      member_in_project: project,
                      member_with_permissions: %i[view_meetings])
  end
  let!(:non_viewer_user) do
    FactoryBot.create(:user,
                      firstname: 'Nonviewer',
                      member_in_project: project,
                      member_with_permissions: %i[])
  end
  let(:meeting) { FactoryBot.create(:meeting, project: project) }
  let(:edit_page) { Pages::Meetings::Edit.new(meeting) }

  let!(:meeting) { FactoryBot.create :meeting, project: project, title: 'Awesome meeting!' }

  before do
    login_as(user)
  end

  it 'allows setting members to participants which are allowed to view the meeting' do
    edit_page.visit!

    edit_page.expect_available_participant(user)
    edit_page.expect_available_participant(viewer_user)

    edit_page.expect_not_available_participant(non_viewer_user)

    edit_page.invite(viewer_user)
    show_page = edit_page.click_save
    show_page.expect_toast(message: 'Successful update')

    show_page.expect_invited(viewer_user)

    show_page.click_edit

    edit_page.uninvite(viewer_user)
    show_page = edit_page.click_save
    show_page.expect_toast(message: 'Successful update')

    show_page.expect_uninvited(viewer_user)
  end

  context 'with an invalid user reference' do
    let(:show_page) { Pages::Meetings::Show.new(meeting) }
    let(:meeting_participant) { FactoryBot.create :meeting_participant, user: viewer_user, meeting: meeting }

    before do
      meeting_participant.update_column(:user_id, 12341234)
    end

    it 'still allows to view the meeting' do
      show_page.visit!

      show_page.expect_invited meeting.author
      show_page.expect_uninvited viewer_user
    end
  end
end
