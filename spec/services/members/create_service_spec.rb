#-- encoding: UTF-8



require 'spec_helper'
require 'services/base_services/behaves_like_create_service'

describe Members::CreateService, type: :model do
  it_behaves_like 'BaseServices create service' do
    let(:call_attributes) do
      {
        project_id: "1",
        user_id: "2",
        role_ids: ["2"],
        notification_message: "Wish you where **here**.",
        send_notifications: true
      }
    end

    let!(:allow_notification_call) do
      allow(ProyeksiApp::Notifications)
        .to receive(:send)
    end

    describe 'if successful' do
      it 'sends a notification' do
        expect(ProyeksiApp::Notifications)
          .to receive(:send)
          .with(ProyeksiApp::Events::MEMBER_CREATED,
                member: model_instance,
                message: call_attributes[:notification_message],
                send_notifications: true)

        subject
      end
    end

    context 'if the SetAttributeService is unsuccessful' do
      let(:set_attributes_success) { false }

      it 'sends no notification' do
        expect(ProyeksiApp::Notifications)
          .not_to receive(:send)

        subject
      end
    end

    context 'when the member is invalid' do
      let(:model_save_result) { false }

      it 'sends no notification' do
        expect(ProyeksiApp::Notifications)
          .not_to receive(:send)

        subject
      end
    end
  end
end
