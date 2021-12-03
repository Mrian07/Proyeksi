

require 'spec_helper'

describe TabsHelper, type: :helper do
  include TabsHelper

  let(:given_tab) do
    { name: 'avatar',
      partial: 'avatars/users/avatar_tab',
      path: ->(params) { edit_user_path(params[:user], tab: :avatar) },
      label: :label_avatar }
  end

  let(:expected_tab) do
    { name: 'avatar',
      partial: 'avatars/users/avatar_tab',
      path: '/users/2/edit/avatar',
      label: :label_avatar }
  end

  describe 'render_extensible_tabs' do
    before do
      allow_any_instance_of(TabsHelper)
        .to receive(:render_tabs)
        .with([expected_tab])
        .and_return [expected_tab]

      allow(::ProyeksiApp::Ui::ExtensibleTabs)
        .to receive(:enabled_tabs)
        .with(:user)
        .and_return [given_tab]

      user = FactoryBot.build(:user, id: 2)
      @tabs = render_extensible_tabs(:user, user: user)
    end

    it "should return an evaluated path" do
      expect(response.status).to eq 200
      expect(@tabs).to eq([expected_tab])
    end
  end
end
