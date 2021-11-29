

require 'spec_helper'

describe 'rendering the login buttons', js: true do
  let(:providers) do
    [
      { name: 'mock_auth' }
    ]
  end

  before do
    allow(OpenProject::Plugins::AuthPlugin).to receive(:providers).and_return(providers)
  end

  describe 'in a public project', with_settings: { login_required: false } do
    let(:public_project) { FactoryBot.build(:project, public: true) }

    it 'renders correctly' do
      visit project_path(public_project)

      page.find('a', text: 'Sign in').click
      item = page.find('a.auth-provider', text: 'mock_auth')
      expect(item[:href]).to end_with '/auth/mock_auth'
    end
  end
end
