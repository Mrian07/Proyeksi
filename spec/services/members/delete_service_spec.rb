

require 'spec_helper'
require 'services/base_services/behaves_like_delete_service'

describe ::Members::DeleteService, type: :model do
  it_behaves_like 'BaseServices delete service' do
    let(:principal) { user }
    before do
      model_instance.principal = principal

      allow(::ProyeksiApp::Notifications)
        .to receive(:send)
    end

    let!(:cleanup_service_instance) do
      instance = instance_double(Members::CleanupService, call: nil)

      allow(Members::CleanupService)
        .to receive(:new)
        .with(principal, model_instance.project_id)
        .and_return(instance)

      instance
    end

    describe '#call' do
      context 'when contract validates and the model is destroyed successfully' do
        it 'calls the cleanup service' do
          service_call

          expect(cleanup_service_instance)
            .to have_received(:call)
        end

        it 'sends a notification' do
          service_call

          expect(::ProyeksiApp::Notifications)
            .to have_received(:send)
            .with(ProyeksiApp::Events::MEMBER_DESTROYED, member: model_instance)
        end

        context 'when the model`s principal is a group' do
          let(:principal) { FactoryBot.build_stubbed(:group) }
          let!(:cleanup_inherited_roles_service_instance) do
            instance = instance_double(Groups::CleanupInheritedRolesService, call: nil)

            allow(Groups::CleanupInheritedRolesService)
              .to receive(:new)
              .with(principal,
                    current_user: user,
                    contract_class: EmptyContract)
              .and_return(instance)

            instance
          end

          it 'calls the cleanup inherited roles service' do
            service_call

            expect(cleanup_inherited_roles_service_instance)
              .to have_received(:call)
          end
        end
      end
    end
  end
end
