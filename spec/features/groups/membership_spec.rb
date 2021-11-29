

require 'spec_helper'

feature 'group memberships through project members page', type: :feature do
  shared_let(:admin) { FactoryBot.create :admin }
  let(:project) { FactoryBot.create :project, name: 'Project 1', identifier: 'project1', members: project_member }

  let(:alice) { FactoryBot.create :user, firstname: 'Alice', lastname: 'Wonderland' }
  let(:bob)   { FactoryBot.create :user, firstname: 'Bob', lastname: 'Bobbit' }
  let(:group) { FactoryBot.create :group, lastname: 'group1' }

  let!(:alpha) { FactoryBot.create :role, name: 'alpha', permissions: [:manage_members] }
  let!(:beta)  { FactoryBot.create :role, name: 'beta' }

  let(:members_page) { Pages::Members.new project.identifier }
  let(:groups_page)  { Pages::Groups.new }
  let(:project_member) { {} }

  before do
    FactoryBot.create :member, user: bob, project: project, roles: [alpha]
  end

  context 'given a group with members' do
    let!(:group) { FactoryBot.create :group, lastname: 'group1', members: alice }
    current_user { bob }

    scenario 'adding group1 as a member with the beta role', js: true do
      members_page.visit!
      members_page.add_user! 'group1', as: 'beta'

      expect(members_page).to have_added_user 'group1'
      expect(members_page).to have_user('Alice Wonderland', group_membership: true)
    end

    context 'which has has been added to a project' do
      let(:project_member) { { group => beta } }

      context 'with the members having no roles of their own' do
        scenario 'removing the group removes its members too' do
          members_page.visit!
          expect(members_page).to have_user('Alice Wonderland')

          members_page.remove_group! 'group1'
          expect(page).to have_text('Removed group1 from project')

          expect(members_page).not_to have_group('group1')
          expect(members_page).not_to have_user('Alice Wonderland')
        end
      end

      context 'with the members having roles of their own' do
        before do
          project.members
            .select { |m| m.user_id == alice.id }
            .each   { |m| m.roles << alpha }
        end

        scenario 'removing the group leaves the user without their group roles' do
          members_page.visit!
          expect(members_page).to have_user('Alice Wonderland', roles: ['alpha', 'beta'])

          members_page.remove_group! 'group1'
          expect(page).to have_text('Removed group1 from project')

          expect(members_page).not_to have_group('group1')

          expect(members_page).to have_user('Alice Wonderland', roles: ['alpha'])
          expect(members_page).not_to have_roles('Alice Wonderland', ['beta'])
        end
      end
    end
  end

  context 'given an empty group in a project' do
    let(:project_member) { { group => beta } }
    current_user { admin }

    before do
      alice # create alice
    end

    scenario 'adding members to that group adds them to the project too', js: true do
      members_page.visit!

      expect(members_page).not_to have_user('Alice Wonderland') # Alice not in the project yet
      expect(members_page).to have_user('group1') # the group is already there though

      groups_page.visit!
      SeleniumHubWaiter.wait
      groups_page.add_user_to_group! 'Alice Wonderland', 'group1'

      members_page.visit!
      expect(members_page).to have_user('Alice Wonderland', roles: ['beta'])
    end
  end
end
