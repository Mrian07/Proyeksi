

require File.expand_path('../spec_helper', __dir__)

describe ProyeksiApp::Webhooks do
  describe '.register_hook' do
    after do
      ProyeksiApp::Webhooks.unregister_hook('testhook1')
    end

    it 'should succeed' do
      ProyeksiApp::Webhooks.register_hook('testhook1') {}
    end
  end

  describe '.find' do
    let!(:hook) { ProyeksiApp::Webhooks.register_hook('testhook3') {} }

    after do
      ProyeksiApp::Webhooks.unregister_hook('testhook3')
    end

    it 'should succeed' do
      expect(ProyeksiApp::Webhooks.find('testhook3')).to equal(hook)
    end
  end

  describe '.unregister_hook' do
    let(:probe) { lambda {} }

    before do
      ProyeksiApp::Webhooks.register_hook('testhook2', &probe)
    end

    it 'should result in the hook no longer being found' do
      ProyeksiApp::Webhooks.unregister_hook('testhook2')
      expect(ProyeksiApp::Webhooks.find('testhook2')).to be_nil
    end
  end
end
