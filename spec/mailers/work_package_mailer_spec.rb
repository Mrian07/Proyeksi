#-- encoding: UTF-8



require 'spec_helper'
require_relative './shared_examples'

describe WorkPackageMailer, type: :mailer do
  include ProyeksiApp::ObjectLinking
  include ActionView::Helpers::UrlHelper
  include ProyeksiApp::StaticRouting::UrlHelpers

  let(:work_package) do
    FactoryBot.build_stubbed(:work_package,
                             type: FactoryBot.build_stubbed(:type_standard),
                             project: project,
                             assigned_to: assignee)
  end
  let(:project) { FactoryBot.build_stubbed(:project) }
  let(:author) { FactoryBot.build_stubbed(:user) }
  let(:recipient) { FactoryBot.build_stubbed(:user) }
  let(:assignee) { FactoryBot.build_stubbed(:user) }
  let(:journal) do
    FactoryBot.build_stubbed(:work_package_journal,
                             journable: work_package,
                             user: author)
  end

  describe '#mentioned' do
    subject(:mail) { described_class.mentioned(recipient, journal) }

    it "has a subject" do
      expect(mail.subject)
        .to eql I18n.t(:'mail.mention.subject',
                       user_name: author.name,
                       id: work_package.id,
                       subject: work_package.subject)
    end

    it 'is sent to the recipient' do
      expect(mail.to)
        .to match_array([recipient.mail])
    end

    it 'has a project header' do
      expect(mail['X-ProyeksiApp-Project'].value)
        .to eql project.identifier
    end

    it 'has a work package id header' do
      expect(mail['X-ProyeksiApp-WorkPackage-Id'].value)
        .to eql work_package.id.to_s
    end

    it 'has a work package author header' do
      expect(mail['X-ProyeksiApp-WorkPackage-Author'].value)
        .to eql work_package.author.login
    end

    it 'has a type header' do
      expect(mail['X-ProyeksiApp-Type'].value)
        .to eql 'WorkPackage'
    end

    it 'has a message id header' do
      Timecop.freeze(Time.current) do
        expect(mail.message_id)
          .to eql "op.journal-#{journal.id}.#{Time.current.strftime('%Y%m%d%H%M%S')}.#{recipient.id}@example.net"
      end
    end

    it 'has a references header' do
      journal_part = "op.journal-#{journal.id}@example.net"
      work_package_part = "op.work_package-#{work_package.id}@example.net"

      expect(mail.references)
        .to eql [work_package_part, journal_part]
    end

    it 'has a work package assignee header' do
      expect(mail['X-ProyeksiApp-WorkPackage-Assignee'].value)
        .to eql work_package.assigned_to.login
    end
  end

  describe '#watcher_changed' do
    subject(:deliveries) { ActionMailer::Base.deliveries }

    let(:watcher_changer) { author }

    context 'for an added watcher' do
      subject(:mail) { described_class.watcher_changed(work_package, recipient, author, 'added') }

      it 'contains the WP subject in the mail subject' do
        expect(mail.subject)
          .to include(work_package.subject)
      end

      it 'has a references header' do
        expect(mail.references)
          .to eql "op.work_package-#{work_package.id}@example.net"
      end
    end

    context 'for a removed watcher' do
      subject(:mail) { described_class.watcher_changed(work_package, recipient, author, 'removed') }

      it 'contains the WP subject in the mail subject' do
        expect(mail.subject)
          .to include(work_package.subject)
      end

      it 'has a references header' do
        expect(mail.references)
          .to eql "op.work_package-#{work_package.id}@example.net"
      end
    end
  end
end
