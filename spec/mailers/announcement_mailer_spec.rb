

require 'spec_helper'

describe AnnouncementMailer, type: :mailer do
  let(:announcement_subject) { 'Some subject' }
  let(:recipient) { FactoryBot.build_stubbed(:user) }
  let(:announcement_body) { 'Some body text' }

  describe '#announce' do
    subject(:mail) do
      described_class.announce(recipient,
                               subject: announcement_subject,
                               body: announcement_body)
    end

    it "has a subject" do
      expect(mail.subject)
        .to eq announcement_subject
    end

    it 'includes the body' do
      expect(mail.body.encoded)
        .to include(announcement_body)
    end

    it "includes the subject in the body as well" do
      expect(mail.body.encoded)
        .to include announcement_subject
    end

    it 'sends to the recipient' do
      expect(mail.to)
        .to match_array [recipient.mail]
    end
  end
end
