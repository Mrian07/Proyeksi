

require 'spec_helper'

require_relative '../support/pages/meetings/index'

describe 'Meetings new', type: :feature do
  let(:project) { FactoryBot.create :project, enabled_module_names: %w[meetings] }
  let(:time_zone) { 'utc' }
  let(:user) do
    FactoryBot.create(:user,
                      lastname: 'First',
                      member_in_project: project,
                      member_with_permissions: permissions).tap do |u|
      u.pref[:time_zone] = time_zone

      u.save!
    end
  end
  let(:other_user) do
    FactoryBot.create(:user,
                      lastname: 'Second',
                      member_in_project: project,
                      member_with_permissions: permissions)
  end
  let(:admin) do
    FactoryBot.create(:admin)
  end
  let(:permissions) { %i[view_meetings create_meetings] }
  let(:current_user) { user }

  before do
    login_as(current_user)
  end

  let(:index_page) { ::Pages::Meetings::Index.new(project) }

  context 'with permission to create meetings' do
    before do
      other_user
    end

    ['CET', 'UTC', '', 'Pacific Time (US & Canada)'].each do |zone|
      let(:time_zone) { zone }

      it "allows creating a project and handles errors in time zone #{zone}" do
        index_page.visit!

        new_page = index_page.click_create_new

        # Error when no title is provided. Only works without js as otherwise html5 would already catch this
        new_page.click_create

        new_page.expect_toast(type: :error, message: "Title can't be blank")

        new_page.set_title 'Some title'
        new_page.set_start_date '2013-03-28'
        new_page.set_start_time '13:30'
        new_page.set_duration '1.5'
        new_page.invite(other_user)

        show_page = new_page.click_create

        show_page.expect_toast(message: 'Successful creation')

        show_page.expect_invited(user, other_user)

        show_page.expect_date_time "03/28/2013 01:30 PM - 03:00 PM"
      end
    end
  end

  context 'without permission to create meetings' do
    let(:permissions) { %i[view_meetings] }

    it 'shows no edit link' do
      index_page.visit!

      index_page.expect_no_create_new_button
    end
  end

  context 'as an admin' do
    let(:current_user) { admin }

    it 'allows creating meeting in a project without members' do
      index_page.visit!

      new_page = index_page.click_create_new

      new_page.set_title 'Some title'

      show_page = new_page.click_create

      show_page.expect_toast(message: 'Successful creation')

      # Not sure if that is then intended behaviour but that is what is currently programmed
      show_page.expect_invited(admin)
    end
  end
end
