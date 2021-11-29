

require 'spec_helper'
require 'services/base_services/behaves_like_create_service'

describe Users::CreateService do
  it_behaves_like 'BaseServices create service' do
    context 'when the user being invited' do
      let(:model_instance) { FactoryBot.build :invited_user }

      context 'and the mail is present' do
        let(:model_instance) { FactoryBot.build :invited_user, mail: 'foo@example.com' }
        it 'will call UserInvitation' do
          expect(::UserInvitation).to receive(:invite_user!).with(model_instance).and_return(model_instance)
          expect(subject).to be_success
        end
      end

      context 'and the user has no names set' do
        let(:model_instance) { FactoryBot.build :invited_user, firstname: nil, lastname: nil, mail: 'foo@example.com' }
        it 'will call UserInvitation' do
          expect(::UserInvitation).to receive(:invite_user!).with(model_instance).and_return(model_instance)
          expect(subject).to be_success
        end
      end

      context 'and the mail is empty' do
        let(:model_instance) { FactoryBot.build :invited_user, mail: nil }
        it 'will call not call UserInvitation' do
          expect(::UserInvitation).not_to receive(:invite_user!)
          expect(subject).not_to be_success
          expect(subject.errors.details[:mail]).to eq [{ error: :blank }]
        end
      end
    end
  end
end
