

require 'spec_helper'

describe ::Sessions::SqlBypass do
  subject { FactoryBot.build(:user_session, user: user) }

  shared_examples 'augments the user_id attribute' do
    it do
      subject.save
      expect(subject.data['user_id']).to eq(user_id)
    end
  end

  describe 'when user_id is present' do
    let(:user) { FactoryBot.build_stubbed(:user) }
    let(:user_id) { user.id }
    it_behaves_like 'augments the user_id attribute'
  end

  describe 'when user_id is nil' do
    let(:user) { nil }
    let(:user_id) { nil }
    it_behaves_like 'augments the user_id attribute'
  end

  describe 'delete other sessions on destroy' do
    let(:user) { FactoryBot.build_stubbed(:user) }
    let!(:sessions) { FactoryBot.create_list(:user_session, 2, user: user) }

    context 'when config is enabled',
            with_config: { drop_old_sessions_on_logout: true } do
      it 'destroys both sessions' do
        expect(::Sessions::UserSession.for_user(user).count).to eq(2)
        sessions.first.destroy

        expect(::Sessions::UserSession.count).to eq(0)
      end
    end

    context 'when config is disabled',
            with_config: { drop_old_sessions_on_logout: false } do
      it 'destroys only the one session' do
        expect(::Sessions::UserSession.for_user(user).count).to eq(2)
        sessions.first.destroy

        expect(::Sessions::UserSession.count).to eq(1)
        expect(::Sessions::UserSession.first.session_id).to eq(sessions[1].session_id)
      end
    end
  end
end
