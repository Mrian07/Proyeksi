

require File.expand_path('../spec_helper', __dir__)

describe Webhooks::Incoming::HooksController, type: :controller do
  let(:hook) { double(ProyeksiApp::Webhooks::Hook) }
  let(:user) { double(User).as_null_object }

  describe '#handle_hook' do
    before do
      expect(ProyeksiApp::Webhooks).to receive(:find).with('testhook').and_return(hook)
      allow(controller).to receive(:find_current_user).and_return(user)
    end

    after do
      # ApplicationController before filter user_setup sets a user
      User.current = nil
    end

    it 'should be successful' do
      expect(hook).to receive(:handle)

      post :handle_hook, params: { hook_name: 'testhook' }

      expect(response).to be_successful
    end

    it 'should call the hook with a user' do
      expect(hook).to receive(:handle) { |_env, _params, user|
        expect(user).to equal(user)
      }

      post :handle_hook, params: { hook_name: 'testhook' }
    end
  end
end
