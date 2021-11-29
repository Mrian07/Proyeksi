

require 'spec_helper'
require 'services/base_services/behaves_like_update_service'

describe Users::UpdateService do
  it_behaves_like 'BaseServices update service' do
    # The user service also tries to save the preferences
    before do
      allow(model_instance.pref).to receive(:save).and_return(true)
    end
  end

  describe 'updating attributes' do
    let(:instance) { described_class.new(model: update_user, user: current_user) }
    let(:current_user) { FactoryBot.build_stubbed(:admin) }
    let(:update_user) { FactoryBot.create(:user, mail: 'correct@example.org') }
    subject { instance.call(attributes: attributes) }

    context 'when invalid' do
      let(:attributes) { { mail: 'invalid' } }

      it 'fails to update' do
        expect(subject).to_not be_success

        update_user.reload
        expect(update_user.mail).to eq('correct@example.org')

        expect(subject.errors.symbols_for(:mail)).to match_array(%i[email])
      end
    end

    context 'when valid' do
      let(:attributes) { { mail: 'new@example.org' } }

      it 'updates the user' do
        expect(subject).to be_success

        update_user.reload
        expect(update_user.mail).to eq('new@example.org')
      end

      context 'if current_user is no admin' do
        let(:current_user) { FactoryBot.build_stubbed(:user) }
        it 'is unsuccessful' do
          expect(subject).to_not be_success
        end
      end
    end

    describe 'updating prefs' do
      let(:attributes) { {} }

      before do
        allow(update_user).to receive(:save).and_return(user_save_result)
      end

      context 'if the user was updated calls the prefs' do
        let(:user_save_result) { true }

        before do
          expect(update_user.pref).to receive(:save).and_return(pref_save_result)
        end

        context 'and the prefs can be saved' do
          let(:pref_save_result) { true }

          it 'returns a successful call' do
            expect(subject).to be_success
          end
        end

        context 'and the prefs can not be saved' do
          let(:pref_save_result) { false }

          it 'returns an erroneous call' do
            expect(subject).not_to be_success
          end
        end
      end

      context 'if the user was not saved' do
        let(:user_save_result) { false }

        it 'does not call #prefs.save' do
          expect(update_user.pref).not_to receive(:save)
          expect(subject).not_to be_success
        end
      end
    end
  end
end
