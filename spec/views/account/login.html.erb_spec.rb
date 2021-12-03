

require 'spec_helper'

describe 'account/login', type: :view do
  context 'with password login enabled' do
    before do
      render
    end

    it 'should show a login field' do
      expect(rendered).to include 'Password'
    end
  end

  context 'with password login disabled' do
    before do
      allow(ProyeksiApp::Configuration).to receive(:disable_password_login?).and_return(true)
      render
    end

    it 'should not show a login field' do
      expect(rendered).not_to include 'Password'
    end
  end
end
