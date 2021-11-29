

require 'spec_helper'

feature 'Group memberships through groups page', type: :feature do
  shared_let(:admin) { FactoryBot.create :admin }
  let!(:project) { FactoryBot.create :project, name: 'Project 1', identifier: 'project1' }

  let!(:peter) { FactoryBot.create :user, firstname: 'Peter', lastname: 'Pan' }

  let!(:manager) { FactoryBot.create :role, name: 'Manager' }

  let(:members_page) { Pages::Members.new project.identifier }

  before do
    allow(User).to receive(:current).and_return admin
  end

  shared_examples 'errors when adding members' do
    scenario 'adding a role without a principal', js: true do
      members_page.visit!
      expect_angular_frontend_initialized
      members_page.add_user! nil, as: 'Manager'

      expect(page).to have_text 'choose at least one user or group'
    end
  end

  context 'creating membership with a user' do
    it_behaves_like 'errors when adding members'
  end
end
