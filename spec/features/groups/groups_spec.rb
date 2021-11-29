

require 'spec_helper'

feature 'group memberships through groups page', type: :feature do
  shared_let(:admin) { FactoryBot.create :admin }
  let!(:group) { FactoryBot.create :group, lastname: "Bob's Team" }

  let(:groups_page) { Pages::Groups.new }

  context 'as an admin' do
    before do
      allow(User).to receive(:current).and_return admin
    end

    scenario 'I can delete a group' do
      groups_page.visit!
      expect(groups_page).to have_group "Bob's Team"

      groups_page.delete_group! "Bob's Team"

      expect(page).to have_selector('.flash.info', text: I18n.t(:notice_deletion_scheduled))
      expect(groups_page).to have_group "Bob's Team"

      perform_enqueued_jobs

      groups_page.visit!
      expect(groups_page).not_to have_group "Bob's Team"
    end
  end
end
