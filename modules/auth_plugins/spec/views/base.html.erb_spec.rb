

require 'spec_helper'

describe 'layouts/base', type: :view do
  describe 'authenticator plugin' do
    include Redmine::MenuManager::MenuHelper
    helper Redmine::MenuManager::MenuHelper
    let(:anonymous) { FactoryBot.build_stubbed(:anonymous) }

    before do
      allow(view).to receive(:current_menu_item).and_return('overview')
      allow(view).to receive(:default_breadcrumb)
      allow(view).to receive(:current_user).and_return anonymous
      allow(ProyeksiApp::Plugins::AuthPlugin).to receive(:providers).and_return([provider])
    end

    context 'with an authenticator with given icon' do
      let(:provider) do
        { name: 'foob_auth', icon: 'image.png' }
      end

      before do
        render
      end

      it 'adds the CSS to render the icon' do
        expect(rendered).to have_text(/background-image:(?:.*)image.png/)
      end
    end
  end
end
