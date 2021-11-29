#-- encoding: UTF-8



require 'spec_helper'
require 'services/base_services/behaves_like_update_service'

describe Groups::UpdateService, type: :model do
  it_behaves_like 'BaseServices update service' do
    let(:add_service_result) do
      ServiceResult.new success: true
    end
    let!(:add_users_service) do
      add_service = instance_double(Groups::AddUsersService)

      allow(Groups::AddUsersService)
        .to receive(:new)
        .with(model_instance, current_user: user)
        .and_return(add_service)

      allow(add_service)
        .to receive(:call)
        .and_return(add_service_result)

      add_service
    end

    context 'with newly created group_users' do
      let(:old_group_user) { FactoryBot.build_stubbed(:group_user, user_id: 3) }
      let(:new_group_user) do
        FactoryBot.build_stubbed(:group_user, user_id: 5).tap do |gu|
          allow(gu)
            .to receive(:saved_changes?)
            .and_return(true)
        end
      end
      let(:group_users) { [old_group_user, new_group_user] }

      before do
        allow(model_instance)
          .to receive(:group_users)
          .and_return(group_users)
      end

      context 'with the AddUsersService being successful' do
        it 'is successful' do
          expect(instance_call).to be_success
        end

        it 'calls the AddUsersService' do
          instance_call

          expect(add_users_service)
            .to have_received(:call)
            .with(ids: [new_group_user.user_id])
        end
      end

      context 'with the AddUsersService being unsuccessful' do
        let(:add_service_result) do
          ServiceResult.new success: false
        end

        it 'is failure' do
          expect(instance_call).to be_failure
        end

        it 'calls the AddUsersService' do
          instance_call

          expect(add_users_service)
            .to have_received(:call)
            .with(ids: [new_group_user.user_id])
        end
      end

      context 'without any new group_users' do
        let(:group_users) { [old_group_user] }

        it 'is successful' do
          expect(instance_call).to be_success
        end

        it 'does not call the AddUsersService' do
          instance_call

          expect(add_users_service)
            .not_to have_received(:call)
        end
      end
    end
  end
end
