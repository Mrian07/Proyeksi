#-- encoding: UTF-8



require 'spec_helper'

describe DigestMailer, type: :mailer do
  include ProyeksiApp::ObjectLinking
  include ActionView::Helpers::UrlHelper
  include ProyeksiApp::StaticRouting::UrlHelpers
  include Redmine::I18n

  let(:recipient) do
    FactoryBot.build_stubbed(:user).tap do |u|
      allow(User)
        .to receive(:find)
              .with(u.id)
              .and_return(u)
    end
  end
  let(:project1) { FactoryBot.build_stubbed(:project) }

  let(:work_package) do
    FactoryBot.build_stubbed(:work_package,
                             type: FactoryBot.build_stubbed(:type))
  end
  let(:journal) do
    FactoryBot.build_stubbed(:work_package_journal,
                             notes: 'Some notes').tap do |j|
      allow(j)
        .to receive(:details)
              .and_return({ "subject" => ["old subject", "new subject"] })
    end
  end
  let(:notifications) do
    [FactoryBot.build_stubbed(:notification,
                              resource: work_package,
                              reason: :commented,
                              journal: journal,
                              project: project1)].tap do |notifications|
      allow(Notification)
        .to receive(:where)
              .and_return(notifications)

      allow(notifications)
        .to receive(:includes)
              .and_return(notifications)
    end
  end

  describe '#work_packages' do
    subject(:mail) { described_class.work_packages(recipient.id, notifications.map(&:id)) }

    let(:mail_body) { mail.body.parts.detect { |part| part['Content-Type'].value == 'text/html' }.body.to_s }

    it 'notes the day and the number of notifications in the subject' do
      expect(mail.subject)
        .to eql "ProyeksiApp - 1 unread notification"
    end

    it 'sends to the recipient' do
      expect(mail.to)
        .to match_array [recipient.mail]
    end

    it 'sets the expected message_id header' do
      allow(Time)
        .to receive(:current)
              .and_return(Time.current)

      expect(mail.message_id)
        .to eql "op.digest.#{Time.current.strftime('%Y%m%d%H%M%S')}.#{recipient.id}@example.net"
    end

    it 'sets the expected proyeksiapp headers' do
      expect(mail['X-ProyeksiApp-User']&.value)
        .to eql recipient.name
    end

    it 'includes the notifications grouped by work package' do
      time_stamp = journal.created_at.strftime('%m/%d/%Y, %I:%M %p')
      expect(mail_body)
        .to have_text("Hey #{recipient.firstname}!")

      expected_notification_subject = "#{work_package.type.name.upcase} #{work_package.subject}"
      expect(mail_body)
        .to have_text(expected_notification_subject, normalize_ws: true)

      expected_notification_header = "#{work_package.status.name} ##{work_package.id} - #{work_package.project}"
      expect(mail_body)
        .to have_text(expected_notification_header, normalize_ws: true)

      expected_text = "#{journal.initial? ? 'Created' : 'Updated'} at #{time_stamp} by #{recipient.name}"
      expect(mail_body)
        .to have_text(expected_text, normalize_ws: true)
    end

    context 'with only a deleted work package for the digest' do
      let(:work_package) { nil }

      it `is a NullMail which isn't sent` do
        expect(mail.body)
          .to eql ''

        expect(mail.header)
          .to eql({})
      end
    end
  end
end
