

require 'spec_helper'

feature 'invite user via email', type: :feature, js: true do
  let!(:project) { FactoryBot.create :project, name: 'Project 1', identifier: 'project1', members: project_members }
  let!(:developer) { FactoryBot.create :role, name: 'Developer' }
  let(:project_members) { {} }

  let(:members_page) { Pages::Members.new project.identifier }

  current_user do
    FactoryBot.create(:user,
                      global_permissions: [:manage_user],
                      member_in_project: project,
                      member_with_permissions: %i[view_members manage_members])
  end

  context 'with a new user' do
    before do
      @old_value = Capybara.raise_server_errors
      Capybara.raise_server_errors = false
    end

    after do
      Capybara.raise_server_errors = @old_value
    end

    scenario 'adds the invited user to the project' do
      members_page.visit!
      click_on 'Add member'

      members_page.search_and_select_principal! 'finkelstein@proyeksiapp.com',
                                                'Send invite to finkelstein@proyeksiapp.com'
      members_page.select_role! 'Developer'
      expect(members_page).to have_selected_new_principal('finkelstein@proyeksiapp.com')

      click_on 'Add'

      expect(members_page).to have_added_user('finkelstein @proyeksiapp.com')

      expect(members_page).to have_user 'finkelstein @proyeksiapp.com'

      # Should show the invited user on the default filter as well
      members_page.visit!
      expect(members_page).to have_user 'finkelstein @proyeksiapp.com'
    end
  end

  context 'with a registered user' do
    let!(:user) do
      FactoryBot.create :user, mail: 'hugo@proyeksiapp.com',
                               login: 'hugo@proyeksiapp.com',
                               firstname: 'Hugo',
                               lastname: 'Hurried'
    end

    scenario 'user lookup by email' do
      members_page.visit!
      click_on 'Add member'

      members_page.search_and_select_principal! 'hugo@proyeksiapp.com',
                                                'Hugo Hurried'
      members_page.select_role! 'Developer'

      click_on 'Add'
      expect(members_page).to have_added_user 'Hugo Hurried'
    end

    context 'who is already a member' do
      let(:project_members) { { user => developer } }

      shared_examples 'no user to invite is found' do
        scenario 'no matches found' do
          members_page.visit!
          click_on 'Add member'

          members_page.search_principal! 'hugo@proyeksiapp.com'
          expect(members_page).to have_no_search_results
        end
      end

      it_behaves_like 'no user to invite is found'

      ##
      # This is a edge case where the email address to be invited is free in principle
      # but there is a user with that email address as their login. Due to this the email address
      # cannot be used after all as the login is the same as the email address for new users
      # which means the login for this invited user will already by taken.
      # Accordingly it should not be offered to invite a user with that email address.
      context 'with different email but email as login' do
        before do
          user.mail = 'foo@bar.de'
          user.save!
        end

        it_behaves_like 'no user to invite is found'
      end
    end
  end
end
