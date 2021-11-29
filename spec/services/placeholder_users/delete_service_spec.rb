

require 'spec_helper'

describe ::PlaceholderUsers::DeleteService, type: :model do
  let(:placeholder_user) { FactoryBot.build_stubbed(:placeholder_user) }
  let(:project) { FactoryBot.build_stubbed(:project) }

  let(:instance) { described_class.new(model: placeholder_user, user: actor) }

  subject { instance.call }

  shared_examples 'deletes the user' do
    it do
      expect(placeholder_user).to receive(:locked!)
      expect(Principals::DeleteJob).to receive(:perform_later).with(placeholder_user)
      expect(subject).to be_success
    end
  end

  shared_examples 'does not delete the user' do
    it do
      expect(placeholder_user).not_to receive(:locked!)
      expect(Principals::DeleteJob).not_to receive(:perform_later)
      expect(subject).not_to be_success
    end
  end

  context 'with admin user' do
    let(:actor) { FactoryBot.build_stubbed(:admin) }

    it_behaves_like 'deletes the user'
  end

  context 'with global user' do
    let(:actor) do
      FactoryBot.build_stubbed(:user).tap do |u|
        allow(u)
          .to receive(:allowed_to_globally?) do |permission|
            [:manage_placeholder_user].include?(permission)
          end
      end
    end

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

    it_behaves_like 'deletes the user' do
      around do |example|
        actor.run_given { example.run }
      end
    end
  end
end
