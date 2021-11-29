#-- encoding: UTF-8



require 'spec_helper'

describe Notifications::WorkflowJob, type: :model do
  subject(:perform_job) do
    described_class.new.perform(state, *arguments)
  end

  let(:send_notification) { true }

  let(:notifications) do
    [FactoryBot.build_stubbed(:notification, reason: :assigned),
     mentioned_notification,
     FactoryBot.build_stubbed(:notification, reason: :watched)]
  end

  let(:mentioned_notification) do
    FactoryBot.build_stubbed(:notification, reason: :mentioned)
  end

  describe '#perform' do
    context 'with the :create_notifications state' do
      let(:state) { :create_notifications }
      let(:arguments) { [resource, send_notification] }
      let(:resource) { FactoryBot.build_stubbed(:comment) }

      let!(:create_service) do
        service_instance = instance_double(Notifications::CreateFromModelService)
        service_result = instance_double(ServiceResult)

        allow(Notifications::CreateFromModelService)
          .to receive(:new)
                .with(resource)
                .and_return(service_instance)

        allow(service_instance)
          .to receive(:call)
                .with(send_notification)
                .and_return(service_result)

        allow(service_result)
          .to receive(:all_results)
                .and_return(notifications)

        service_instance
      end

      let!(:mail_service) do
        service_instance = instance_double(Notifications::MailService,
                                           call: nil)

        allow(Notifications::MailService)
          .to receive(:new)
                .with(mentioned_notification)
                .and_return(service_instance)

        service_instance
      end

      it 'calls the service to create notifications' do
        perform_job

        expect(create_service)
          .to have_received(:call)
                .with(send_notification)
      end

      it 'sends mails for all notifications that are marked to send mails and that have a mention reason' do
        perform_job

        expect(mail_service)
          .to have_received(:call)
      end

      it 'schedules a delayed WorkflowJob for those notifications not to be sent directly' do
        allow(Time)
          .to receive(:current)
                .and_return(Time.current)

        expected_time = Time.current +
                        Setting.journal_aggregation_time_minutes.to_i.minutes

        expect { perform_job }
          .to enqueue_job(described_class)
                .with(:send_mails, *(notifications - [mentioned_notification]).map(&:id))
                .at(expected_time)
      end
    end

    context 'with the :send_mails state' do
      let(:state) { :send_mails }
      let(:arguments) { notifications.map(&:id) }

      let!(:mail_service) do
        service_instance = instance_double(Notifications::MailService,
                                           call: nil)

        allow(Notifications::MailService)
          .to receive(:new)
                .with(notifications.first)
                .and_return(service_instance)

        service_instance
      end

      before do
        scope = class_double(Notification, mail_alert_unsent: [notifications.first])

        allow(Notification)
          .to receive(:where)
                .with(id: notifications.map(&:id))
                .and_return(scope)
      end

      it 'sends mails for all notifications that are marked to send mails' do
        perform_job

        expect(mail_service)
          .to have_received(:call)
      end
    end
  end
end
