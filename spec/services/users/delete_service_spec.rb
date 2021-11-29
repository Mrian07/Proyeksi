

require 'spec_helper'

describe ::Users::DeleteService, type: :model do
  let(:input_user) { FactoryBot.build_stubbed(:user) }
  let(:project) { FactoryBot.build_stubbed(:project) }

  let(:instance) { described_class.new(model: input_user, user: actor) }

  subject { instance.call }

  shared_examples 'deletes the user' do
    it do
      allow(input_user).to receive(:update_column).with(:status, 3)
      expect(Principals::DeleteJob).to receive(:perform_later).with(input_user)
      expect(subject).to be_success
      expect(input_user).to have_received(:update_column).with(:status, 3)
    end
  end

  shared_examples 'does not delete the user' do
    it do
      allow(input_user).to receive(:update_column).with(:status, 3)
      expect(Principals::DeleteJob).not_to receive(:perform_later)
      expect(subject).not_to be_success
      expect(input_user).not_to have_received(:update_column).with(:status, 3)
    end
  end

  context 'if deletion by admins allowed', with_settings: { users_deletable_by_admins: true } do
    context 'with admin user' do
      let(:actor) { FactoryBot.build_stubbed(:admin) }

      it_behaves_like 'deletes the user'
    end

    context 'with unprivileged system user' do
      let(:actor) { User.system }

      before do
        allow(actor).to receive(:admin?).and_return false
      end

      it_behaves_like 'does not delete the user'
    end

    context 'with privileged system user' do
      let(:actor) { User.system }

      it_behaves_like 'deletes the user'
    end
  end

  context 'if deletion by admins NOT allowed', with_settings: { users_deletable_by_admins: false } do
    context 'with admin user' do
      let(:actor) { FactoryBot.build_stubbed(:admin) }

      it_behaves_like 'does not delete the user'
    end

    context 'with system user' do
      let(:actor) { User.system }

      it_behaves_like 'does not delete the user'
    end
  end
end
