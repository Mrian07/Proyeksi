

require 'spec_helper'

describe 'admin/settings/authentication_settings/show', type: :view do
  context 'with password login enabled' do
    before do
      allow(OpenProject::Configuration).to receive(:disable_password_login?).and_return(false)
      render
    end

    it 'shows password settings' do
      expect(rendered).to have_text I18n.t('label_password_lost')
    end

    it 'shows automated user blocking options' do
      expect(rendered).to have_text I18n.t(:brute_force_prevention, scope: [:settings])
    end
  end

  context 'with password login disabled' do
    before do
      allow(OpenProject::Configuration).to receive(:disable_password_login?).and_return(true)
      render
    end

    it 'does not show password settings' do
      expect(rendered).not_to have_text I18n.t('label_password_lost')
    end

    it 'does not show automated user blocking options' do
      expect(rendered).not_to have_text I18n.t(:brute_force_prevention, scope: [:settings])
    end
  end

  context 'with no registration_footer configured' do
    before do
      allow(OpenProject::Configuration).to receive(:registration_footer).and_return({})
      render
    end

    it 'shows the registration footer textfield' do
      expect(rendered).to have_text I18n.t(:setting_registration_footer)
    end
  end

  context 'with registration_footer configured' do
    before do
      allow(OpenProject::Configuration)
        .to receive(:registration_footer)
        .and_return("en" => "You approve.")

      render
    end

    it 'does not show the registration footer textfield' do
      expect(rendered).not_to have_text I18n.t(:setting_registration_footer)
    end
  end
end
