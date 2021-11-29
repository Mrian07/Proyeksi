

require 'spec_helper'

describe Queries::WorkPackages::Filter::AuthorFilter, type: :model do
  it_behaves_like 'basic query filter' do
    let(:type) { :list }
    let(:class_key) { :author_id }

    let(:user_1) { FactoryBot.build_stubbed(:user) }

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
      let(:logged_in) { true }

      before do
        allow(User)
          .to receive_message_chain(:current, :logged?)
          .and_return(logged_in)
      end

      context 'when being logged in' do
        it 'is true if no other user is available' do
          expect(instance).to be_available
        end

        it 'is true if there is another user selectable' do
          allow(principal_loader)
            .to receive(:user_values)
            .and_return([[user_1.name, user_1.id.to_s]])

          expect(instance).to be_available
        end
      end

      context 'when not being logged in' do
        let(:logged_in) { false }

        it 'is false if no other user is available' do
          expect(instance).to_not be_available
        end

        it 'is true if there is another user selectable' do
          allow(principal_loader)
            .to receive(:user_values)
            .and_return([[user_1.name, user_1.id.to_s]])

          expect(instance).to be_available
        end
      end
    end

    describe '#allowed_values' do
      let(:logged_in) { true }

      before do
        allow(User)
          .to receive_message_chain(:current, :logged?)
          .and_return(logged_in)
      end

      context 'when being logged in' do
        it 'returns the me value and the available users' do
          allow(principal_loader)
            .to receive(:user_values)
            .and_return([[user_1.name, user_1.id.to_s]])

          expect(instance.allowed_values)
            .to match_array([[I18n.t(:label_me), 'me'],
                             [user_1.name, user_1.id.to_s]])
        end
      end

      context 'when not being logged in' do
        let(:logged_in) { false }

        it 'returns the available users' do
          allow(principal_loader)
            .to receive(:user_values)
            .and_return([[user_1.name, user_1.id.to_s]])

          expect(instance.allowed_values)
            .to match_array([[user_1.name, user_1.id.to_s]])
        end
      end
    end
  end
end
