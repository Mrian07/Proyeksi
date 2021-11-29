

require 'spec_helper'

describe ::Users::DeleteService, 'Integration', type: :model do
  let(:input_user) { FactoryBot.create(:user) }
  let(:actor) { FactoryBot.build_stubbed(:admin) }

  let(:instance) { described_class.new(model: input_user, user: actor) }

  subject { instance.call }

  context 'when input user is invalid',
          with_settings: { users_deletable_by_admins: true } do
    before do
      input_user.update_column(:mail, '')
    end

    it 'can still delete the user' do
      expect(input_user).not_to be_valid

      expect(subject).to be_success

      expect(Principals::DeleteJob).to have_been_enqueued.with(input_user)
    end
  end
end
