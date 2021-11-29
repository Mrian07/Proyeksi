#-- encoding: UTF-8



require 'spec_helper'
require 'services/base_services/behaves_like_create_service'

describe Projects::CreateService, type: :model do
  it_behaves_like 'BaseServices create service' do
    let(:new_project_role) { FactoryBot.build_stubbed(:role) }
    let(:create_member_instance) { instance_double(Members::CreateService) }

    before do
      allow(Role)
        .to(receive(:in_new_project))
        .and_return(new_project_role)

      allow(Members::CreateService)
        .to(receive(:new))
        .with(user: user, contract_class: EmptyContract)
        .and_return(create_member_instance)

      allow(create_member_instance)
        .to(receive(:call))
    end

    it 'adds the current user to the project' do
      subject

      expect(create_member_instance)
        .to have_received(:call)
        .with(principal: user,
              project: model_instance,
              roles: [new_project_role])
    end

    context 'current user is admin' do
      it 'does not add the user to the project' do
        allow(user)
          .to(receive(:admin?))
          .and_return(true)

        subject

        expect(create_member_instance)
          .not_to(have_received(:call))
      end
    end
  end
end
