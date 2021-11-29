#-- encoding: UTF-8



require 'spec_helper'

describe Notifications::MailService, type: :model do
  subject(:call) { instance.call }

  let(:recipient) do
    FactoryBot.build_stubbed(:user)
  end
  let(:actor) do
    FactoryBot.build_stubbed(:user)
  end
  let(:instance) { described_class.new(notification) }

  context 'with a document journal notification' do
    let(:journal) do
      FactoryBot.build_stubbed(:journal,
                               journable: FactoryBot.build_stubbed(:document)).tap do |j|
        allow(j)
          .to receive(:initial?)
                .and_return(initial_journal)
      end
    end
    let(:read_ian) { false }
    let(:notification) do
      FactoryBot.build_stubbed(:notification,
                               journal: journal,
                               resource: journal.journable,
                               recipient: recipient,
                               actor: actor,
                               read_ian: read_ian)
    end
    let(:notification_setting) { %w(document_added) }
    let(:mail) do
      mail = instance_double(ActionMailer::MessageDelivery)

      allow(DocumentsMailer)
        .to receive(:document_added)
              .and_return(mail)

      allow(mail)
        .to receive(:deliver_later)

      mail
    end
    let(:initial_journal) { true }

    before do
      mail
    end

    it 'sends a mail' do
      call

      expect(DocumentsMailer)
        .to have_received(:document_added)
              .with(recipient,
                    journal.journable)

      expect(mail)
        .to have_received(:deliver_later)
    end

    context 'with the notification read in app already' do
      let(:read_ian) { true }

      it 'sends no mail' do
        call

        expect(DocumentsMailer)
          .not_to have_received(:document_added)
      end
    end

    context 'with the journal not being the initial one' do
      let(:initial_journal) { false }

      it 'sends no mail' do
        call

        expect(DocumentsMailer)
          .not_to have_received(:document_added)
      end
    end
  end
end
