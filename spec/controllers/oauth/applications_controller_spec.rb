

require 'spec_helper'
require 'work_package'

describe ::OAuth::ApplicationsController, type: :controller do
  let(:user) { FactoryBot.build_stubbed :admin }
  let(:application_stub) { FactoryBot.build_stubbed(:oauth_application, id: 1, secret: 'foo') }

  before do
    login_as user
  end

  context 'not logged as admin' do
    let(:user) { FactoryBot.build_stubbed :user }

    it 'does not grant access' do
      get :index
      expect(response.response_code).to eq 403

      get :new
      expect(response.response_code).to eq 403

      get :edit, params: { id: 1 }
      expect(response.response_code).to eq 403

      post :create
      expect(response.response_code).to eq 403

      put :update, params: { id: 1 }
      expect(response.response_code).to eq 403

      delete :destroy, params: { id: 1 }
      expect(response.response_code).to eq 403
    end
  end

  describe '#new' do
    it do
      get :new
      expect(response.status).to eql 200
      expect(response).to render_template :new
    end
  end

  describe '#edit' do
    before do
      allow(::Doorkeeper::Application)
        .to receive(:find)
        .with('1')
        .and_return(application_stub)
    end

    it do
      get :edit, params: { id: 1, application: { name: 'foo' } }
      expect(response.status).to eql 200
      expect(response).to render_template :edit
    end
  end

  describe '#create' do
    before do
      allow(::Doorkeeper::Application)
        .to receive(:new)
        .and_return(application_stub)
      expect(application_stub).to receive(:attributes=)
      expect(application_stub).to receive(:save).and_return(true)
      expect(application_stub).to receive(:plaintext_secret).and_return('secret!')
    end

    it do
      post :create, params: { application: { name: 'foo' } }
      expect(response).to redirect_to action: :show, id: application_stub.id
    end
  end

  describe '#update' do
    before do
      allow(::Doorkeeper::Application)
        .to receive(:find)
        .with('1')
        .and_return(application_stub)
      expect(application_stub).to receive(:attributes=)
      expect(application_stub).to receive(:save).and_return(true)
    end

    it do
      patch :update, params: { id: 1, application: { name: 'foo' } }
      expect(response).to redirect_to action: :index
    end
  end

  describe '#destroy' do
    before do
      allow(::Doorkeeper::Application)
        .to receive(:find)
        .with('1')
        .and_return(application_stub)
      expect(application_stub).to receive(:destroy).and_return(true)
    end

    it do
      delete :destroy, params: { id: 1 }
      expect(flash[:notice]).to be_present
      expect(response).to redirect_to action: :index
    end
  end
end
