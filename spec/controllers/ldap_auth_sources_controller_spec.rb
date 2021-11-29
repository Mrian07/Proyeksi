

require 'spec_helper'

describe LdapAuthSourcesController, type: :controller do
  let(:current_user) { FactoryBot.create(:admin) }

  before do
    allow(User).to receive(:current).and_return current_user
  end

  describe 'new' do
    before do
      get :new
    end

    it { expect(assigns(:auth_source)).not_to be_nil }
    it { is_expected.to respond_with :success }
    it { is_expected.to render_template :new }

    it 'initializes a new AuthSource' do
      expect(assigns(:auth_source).class).to eq LdapAuthSource
      expect(assigns(:auth_source)).to be_new_record
    end
  end
end
