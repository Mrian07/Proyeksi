

require 'spec_helper'

describe AuthSourcesController, type: :controller do
  let(:current_user) { FactoryBot.create(:admin) }

  before do
    allow(ProyeksiApp::Configuration).to receive(:disable_password_login?).and_return(false)

    allow(User).to receive(:current).and_return current_user
  end

  describe 'index' do
    before do
      get :index
    end

    it { expect(assigns(:auth_source)).to eq @auth_source }
    it { is_expected.to respond_with :success }
    it { is_expected.to render_template :index }
  end

  describe 'new' do
    before do
      get :new
    end

    it { expect(assigns(:auth_source)).not_to be_nil }
    it { is_expected.to respond_with :success }
    it { is_expected.to render_template :new }

    it 'initializes a new AuthSource' do
      expect(assigns(:auth_source).class).to eq(AuthSource)
      expect(assigns(:auth_source)).to be_new_record
    end
  end

  describe 'create' do
    before do
      post :create, params: { auth_source: { name: 'Test' } }
    end

    it { is_expected.to respond_with :redirect }
    it { is_expected.to redirect_to auth_sources_path }
    it { is_expected.to set_flash.to /success/i }
  end

  describe 'edit' do
    before do
      @auth_source = FactoryBot.create(:auth_source, name: 'TestEdit')
      get :edit, params: { id: @auth_source.id }
    end

    it { expect(assigns(:auth_source)).to eq @auth_source }
    it { is_expected.to respond_with :success }
    it { is_expected.to render_template :edit }
  end

  describe 'update' do
    before do
      @auth_source = FactoryBot.create(:auth_source, name: 'TestEdit')
      post :update, params: { id: @auth_source.id, auth_source: { name: 'TestUpdate' } }
    end

    it { is_expected.to respond_with :redirect }
    it { is_expected.to redirect_to auth_sources_path }
    it { is_expected.to set_flash.to /update/i }
  end

  describe 'destroy' do
    before do
      @auth_source = FactoryBot.create(:auth_source, name: 'TestEdit')
    end

    context 'without users' do
      before do
        post :destroy, params: { id: @auth_source.id }
      end

      it { is_expected.to respond_with :redirect }
      it { is_expected.to redirect_to auth_sources_path }
      it { is_expected.to set_flash.to /deletion/i }
    end

    context 'with users' do
      before do
        FactoryBot.create(:user, auth_source: @auth_source)
        post :destroy, params: { id: @auth_source.id }
      end

      it { is_expected.to respond_with :redirect }

      it 'doesn not destroy the AuthSource' do
        expect(AuthSource.find(@auth_source.id)).not_to be_nil
      end
    end
  end

  context 'with password login disabled' do
    before do
      allow(ProyeksiApp::Configuration).to receive(:disable_password_login?).and_return(true)
    end

    it 'cannot find index' do
      get :index

      expect(response.status).to eq 404
    end

    it 'cannot find new' do
      get :new

      expect(response.status).to eq 404
    end

    it 'cannot find create' do
      post :create, params: { auth_source: { name: 'Test' } }

      expect(response.status).to eq 404
    end

    it 'cannot find edit' do
      get :edit, params: { id: 42 }

      expect(response.status).to eq 404
    end

    it 'cannot find update' do
      post :update, params: { id: 42, auth_source: { name: 'TestUpdate' } }

      expect(response.status).to eq 404
    end

    it 'cannot find destroy' do
      post :destroy, params: { id: 42 }

      expect(response.status).to eq 404
    end
  end
end
