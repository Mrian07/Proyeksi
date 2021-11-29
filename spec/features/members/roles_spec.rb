

require 'spec_helper'

describe 'members pagination', type: :feature, js: true do
  shared_let(:admin) { FactoryBot.create :admin }
  let(:project) do
    FactoryBot.create :project,
                      name: 'Project 1',
                      identifier: 'project1',
                      members: {
                        alice => beta,
                        bob => alpha
                      }
  end

  let(:bob)   { FactoryBot.create :user, firstname: 'Bob', lastname: 'Bobbit' }
  let(:alice) { FactoryBot.create :user, firstname: 'Alice', lastname: 'Alison' }

  let(:alpha) { FactoryBot.create :role, name: 'alpha' }
  let(:beta)  { FactoryBot.create :role, name: 'beta' }

  let(:members_page) { Pages::Members.new project.identifier }

  current_user { admin }

  before do
    members_page.visit!
  end

  scenario 'Adding a Role to Alice' do
    members_page.edit_user! 'Alice Alison', add_roles: ['alpha']

    expect(members_page).to have_user('Alice Alison', roles: ['alpha', 'beta'])
  end

  scenario 'Adding a role while taking another role away from Alice' do
    members_page.edit_user! 'Alice Alison', add_roles: ['alpha'], remove_roles: ['beta']

    expect(members_page).to have_user('Alice Alison', roles: 'alpha')
    expect(members_page).not_to have_roles('Alice Alison', ['beta'])
  end

  scenario "Removing Bob's last role results in an error" do
    members_page.edit_user! 'Bob Bobbit', remove_roles: ['alpha']

    expect(page).to have_text 'Roles need to be assigned.'
    expect(members_page).to have_user('Bob Bobbit', roles: ['alpha'])
  end
end
