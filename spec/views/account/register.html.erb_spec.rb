

require 'spec_helper'

describe 'account/register', type: :view do
  let(:user) { FactoryBot.build :user, auth_source: nil }

  context 'with the email_login setting disabled (default value)' do
    before do
      allow(Setting).to receive(:email_login?).and_return(false)

      assign(:user, user)
      render
    end

    context 'with auth source' do
      let(:auth_source) { FactoryBot.create :auth_source }
      let(:user)        { FactoryBot.build :user, auth_source: auth_source }

      it 'should not show a login field' do
        expect(rendered).not_to include('user[login]')
      end
    end

    context 'without auth source' do
      it 'should show a login field' do
        expect(rendered).to include('user[login]')
      end
    end
  end

  context 'with the email_login setting enabled' do
    before do
      allow(Setting).to receive(:email_login?).and_return(true)

      assign(:user, user)
      render
    end

    context 'with auth source' do
      let(:auth_source) { FactoryBot.create :auth_source }
      let(:user)        { FactoryBot.build :user, auth_source: auth_source }

      it 'should not show a login field' do
        expect(rendered).not_to include('user[login]')
      end

      it 'should show an email field' do
        expect(rendered).to include('user[mail]')
      end
    end

    context 'without auth source' do
      it 'should not show a login field' do
        expect(rendered).not_to include('user[login]')
      end

      it 'should show an email field' do
        expect(rendered).to include('user[mail]')
      end
    end
  end

  context 'with the registration_footer setting enabled' do
    let(:footer) { "Some email footer" }

    before do
      allow(Setting).to receive(:registration_footer).and_return("en" => footer)

      assign(:user, user)
    end

    it 'should render the registration footer from the settings' do
      render

      expect(rendered).to include(footer)
    end

    context 'with a registration footer in the ProyeksiApp configuration' do
      before do
        allow(ProyeksiApp::Configuration).to receive(:registration_footer).and_return("en" => footer.reverse)
      end

      it 'should render the registration footer from the configuration, overriding the settings' do
        render

        expect(rendered).to include(footer.reverse)
      end
    end
  end

  context "with consent required", with_settings: {
    consent_required: true,
    consent_info: {
      en: "You must consent!",
      de: "Du musst zustimmen!"
    }
  } do
    let(:locale) { raise "you have to define the locale" }

    before do
      I18n.with_locale(locale) do
        render
      end
    end

    context "for English (locale: en) users" do
      let(:locale) { :en }

      it "shows the registration page and consent info in English" do
        expect(rendered).to include "new account"
        expect(rendered).to include "consent!"
      end
    end

    context "for German (locale: de) users" do
      let(:locale) { :de }

      it "shows the registration page consent info in German" do
        expect(rendered).to include "Neues Konto"
        expect(rendered).to include "zustimmen!"
      end
    end
  end
end
