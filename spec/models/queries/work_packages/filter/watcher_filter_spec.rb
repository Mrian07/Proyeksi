

require 'spec_helper'

describe Queries::WorkPackages::Filter::WatcherFilter, type: :model do
  let(:user) { FactoryBot.build_stubbed(:user) }

  it_behaves_like 'basic query filter' do
    let(:type) { :list }
    let(:class_key) { :watcher_id }

    let(:principal_loader) do
      loader = double('principal_loader')
      allow(loader)
        .to receive(:user_values)
        .and_return([])

      loader
    end

    before do
      allow(Queries::WorkPackages::Filter::PrincipalLoader)
        .to receive(:new)
        .with(project)
        .and_return(principal_loader)
    end

    describe '#available?' do
      it 'is true if the user is logged in' do
        allow(User)
          .to receive_message_chain(:current, :logged?)
          .and_return true

        expect(instance).to be_available
      end

      it 'is true if the user is allowed to see watchers and if there are users' do
        allow(User)
          .to receive_message_chain(:current, :logged?)
          .and_return false

        allow(User)
          .to receive_message_chain(:current, :allowed_to?)
          .and_return true

        allow(principal_loader)
          .to receive(:user_values)
          .and_return([user])

        expect(instance).to be_available
      end

      it 'is false if the user is allowed to see watchers but there are no users' do
        allow(User)
          .to receive_message_chain(:current, :logged?)
          .and_return false

        allow(User)
          .to receive_message_chain(:current, :allowed_to?)
          .and_return true

        allow(principal_loader)
          .to receive(:user_values)
          .and_return([])

        expect(instance).to_not be_available
      end

      it 'is false if the user is not allowed to see watchers but there are users' do
        allow(User)
          .to receive_message_chain(:current, :logged?)
          .and_return false

        allow(User)
          .to receive_message_chain(:current, :allowed_to?)
          .and_return false

        allow(principal_loader)
          .to receive(:user_values)
          .and_return([user])

        expect(instance).to_not be_available
      end
    end

    describe '#allowed_values' do
      context 'contains the me value if the user is logged in' do
        before do
          allow(User)
            .to receive_message_chain(:current, :logged?)
            .and_return true

          expect(instance.allowed_values)
            .to match_array [[I18n.t(:label_me), 'me']]
        end
      end

      context 'contains the user values loaded if the user is allowed to see them' do
        before do
          allow(User)
            .to receive_message_chain(:current, :logged?)
            .and_return true

          allow(User)
            .to receive_message_chain(:current, :allowed_to?)
            .and_return true

          allow(principal_loader)
            .to receive(:user_values)
            .and_return([user])

          expect(instance.allowed_values)
            .to match_array [[I18n.t(:label_me), 'me'],
                             [user.name, user.id.to_s]]
        end
      end
    end

    describe '#ar_object_filter?' do
      it 'is true' do
        expect(instance)
          .to be_ar_object_filter
      end
    end

    describe '#value_objects' do
      let(:user1) { FactoryBot.build_stubbed(:user) }

      before do
        allow(Principal)
          .to receive(:where)
          .with(id: [user1.id.to_s])
          .and_return([user1])

        instance.values = [user1.id.to_s]
      end

      it 'returns an array of users' do
        expect(instance.value_objects)
          .to match_array([user1])
      end
    end
  end
end
