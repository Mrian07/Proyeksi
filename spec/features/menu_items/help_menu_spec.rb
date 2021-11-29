

require 'spec_helper'

feature 'Help menu items' do
  let(:user) { FactoryBot.create :admin }
  let(:help_item) { find('.op-app-help .op-app-menu--item-action') }

  before do
    login_as user
  end

  describe 'When force_help_link is not set', js: true do
    it 'renders a dropdown' do
      visit home_path

      help_item.click
      expect(page).to have_selector('.op-app-help .op-menu--item-action',
                                    text: I18n.t('homescreen.links.user_guides'))
    end
  end

  describe 'When force_help_link is set', js: true do
    let(:custom_url) { 'https://mycustomurl.example.org/' }
    before do
      allow(OpenProject::Configuration).to receive(:force_help_link)
        .and_return custom_url
    end
    it 'renders a link' do
      visit home_path

      expect(help_item[:href]).to eq(custom_url)
      expect(page).to have_no_selector('.op-app-help .op-app-menu--dropdown', visible: false)
    end
  end
end
