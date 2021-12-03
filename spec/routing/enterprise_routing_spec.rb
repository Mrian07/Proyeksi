

require 'spec_helper'

describe EnterprisesController, type: :routing do
  context "when `ee_manager_visible`" do
    it 'should connect GET /admin/enterprise to enterprises#show' do
      allow(ProyeksiApp::Configuration).to receive(:ee_manager_visible?).and_return(true)
      expect(get('/admin/enterprise')).to route_to(controller: 'enterprises',
                                                   action: 'show')
    end
  end

  context "when NOT `ee_manager_visible`" do
    it 'GET /admin/enterprise should not route to enterprise#show' do
      # With such a configuration and in case a token is present, the might be a
      # good reason not to reveal the enterpise token to the admin.
      # Think of cloud solutions for instance.
      allow(ProyeksiApp::Configuration).to receive(:ee_manager_visible?).and_return(false)
      expect(get('/admin/enterprise')).not_to route_to(controller: 'enterprises',
                                                       action: 'show')
    end
  end
end
