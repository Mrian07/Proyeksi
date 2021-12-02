

require 'spec_helper'

describe UserInvitation do
  describe '.reinvite_user' do
    let(:user) { FactoryBot.create :invited_user }
    let!(:token) { FactoryBot.create :invitation_token, user: user }

    it 'notifies listeners of the re-invite' do
      expect(ProyeksiApp::Notifications).to receive(:send) do |event, _new_token|
        expect(event).to eq 'user_reinvited'
      end

      UserInvitation.reinvite_user user.id
    end

    it 'creates a new token' do
      new_token = UserInvitation.reinvite_user user.id

      expect(new_token.value).not_to eq token.value
      expect(Token::Invitation.exists?(token.id)).to eq false
    end
  end
end
