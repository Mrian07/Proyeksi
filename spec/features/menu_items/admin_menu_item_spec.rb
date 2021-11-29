

require 'spec_helper'

feature 'Admin menu items' do
  let(:user) { FactoryBot.create :admin }

  before do
    allow(User).to receive(:current).and_return user
  end

  after do
    OpenProject::Configuration['hidden_menu_items'] = []
  end

  describe 'displaying all the menu items' do
    it 'hides the specified admin menu items' do
      visit admin_index_path

      expect(page).to have_selector('a', text: I18n.t('label_user_plural'))
      expect(page).to have_selector('a', text: I18n.t('label_role_plural'))
      expect(page).to have_selector('a', text: I18n.t('label_type_plural'))
    end
  end

  describe 'hiding menu items' do
    before do
      OpenProject::Configuration['hidden_menu_items'] = { 'admin_menu' => ['roles', 'types'] }
    end

    it 'hides the specified admin menu items' do
      visit admin_index_path

      expect(page).to have_selector('a', text: I18n.t('label_user_plural'))

      expect(page).not_to have_selector('a', text: I18n.t('label_role_plural'))
      expect(page).not_to have_selector('a', text: I18n.t('label_type_plural'))
    end
  end
end
