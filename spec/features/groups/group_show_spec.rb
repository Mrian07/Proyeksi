

require 'spec_helper'

feature 'group show page', type: :feature do
  let!(:member) { FactoryBot.create :user }
  let!(:group) { FactoryBot.create :group, lastname: "Bob's Team", members: [member] }

  before do
    login_as current_user
  end

  context 'as an admin' do
    shared_let(:admin) { FactoryBot.create :admin }
    let(:current_user) { admin }

    scenario 'I can visit the group page' do
      visit show_group_path(group)
      expect(page).to have_selector('h2', text: "Bob's Team")
      expect(page).to have_selector('.toolbar-item', text: 'Edit')
      expect(page).to have_selector('li', text: member.name)
    end
  end

  context 'as a regular user' do
    let(:current_user) { FactoryBot.create :user }

    scenario 'I can visit the group page' do
      visit show_group_path(group)
      expect(page).to have_selector('h2', text: "Bob's Team")
      expect(page).to have_no_selector('.toolbar-item')
      expect(page).to have_no_selector('li', text: member.name)
    end
  end
end
