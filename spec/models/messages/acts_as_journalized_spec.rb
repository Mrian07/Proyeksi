

require 'spec_helper'

describe Message, 'acts_as_journalized', type: :model do
  let(:user) { FactoryBot.create(:user) }
  let(:project) { FactoryBot.create(:project) }
  let!(:forum) do
    FactoryBot.create(:forum,
                      project: project)
  end
  let(:attachment) { FactoryBot.create(:attachment, container: nil, author: user) }

  context 'on creation' do
    context 'attachments' do
      before do
        Message.create! forum: forum, subject: 'Test message', content: 'Message body', attachments: [attachment]
      end
      let(:attachment_id) { "attachments_#{attachment.id}" }
      let(:filename) { attachment.filename }

      subject { Message.last.journals.last.details }

      it { is_expected.to have_key attachment_id }

      it { expect(subject[attachment_id]).to eq([nil, filename]) }
    end
  end
end
