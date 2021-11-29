

require File.expand_path('../spec_helper', __dir__)

describe OpenProject::Webhooks::Hook do
  describe '#relative_url' do
    let(:hook) { OpenProject::Webhooks::Hook.new('myhook') }

    it "should return the correct URL" do
      expect(hook.relative_url).to eql('webhooks/myhook')
    end
  end

  describe '#handle' do
    let(:probe) { lambda {} }
    let(:hook) { OpenProject::Webhooks::Hook.new('myhook', &probe) }

    before do
      expect(probe).to receive(:call).with(hook, 1, 2, 3)
    end

    it 'should execute the callback with the correct parameters' do
      hook.handle(1, 2, 3)
    end
  end
end
