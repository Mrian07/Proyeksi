

require 'spec_helper'

describe 'rendering the login buttons for all providers' do
  let(:providers) do
    [
      { name: 'mock_auth' },
      { name: 'test_auth', display_name: 'Test' },
      { name: 'foob_auth', icon: 'foobar.png' }
    ]
  end

  before do
    allow(OpenProject::Plugins::AuthPlugin).to receive(:providers).and_return(providers)

    render partial: 'hooks/login/providers', handlers: [:erb], formats: [:html]
  end

  it 'should show the mock_auth button with the name as its label' do
    expect(rendered).to match /#{providers[0][:name]}/
  end

  it 'should show the test_auth button with the given display_name as its label' do
    expect(rendered).to match /#{providers[1][:display_name]}/
  end

  context 'with relative url root', with_config: { rails_relative_url_root: '/foobar' } do
    it 'renders correctly' do
      expect(rendered).to include '/foobar/auth/mock_auth'
    end
  end
end
