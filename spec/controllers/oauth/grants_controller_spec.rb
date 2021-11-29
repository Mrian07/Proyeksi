

require 'spec_helper'
require 'work_package'

describe ::OAuth::GrantsController, type: :controller do
  let(:user) { FactoryBot.build_stubbed :user }
  let(:application_stub) { instance_double(::Doorkeeper::Application, name: 'Foo', id: 1) }

  before do
    login_as user
  end

  describe '#revoke_application' do
    context 'when not found' do
      it 'renders 404' do
        post :revoke_application, params: { application_id: 1234 }
        expect(flash[:notice]).to be_nil
        expect(response.response_code).to eq 404
      end
    end

    context 'when found' do
      before do
        allow(controller)
          .to receive(:find_application)
          .and_return(application_stub)
      end

      it do
        post :revoke_application, params: { application_id: 1 }
        expect(flash[:notice]).to include 'Foo'
        expect(response).to redirect_to controller: '/my', action: :access_token
      end
    end
  end
end
