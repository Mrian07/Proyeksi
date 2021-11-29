

require 'spec_helper'

describe MessagesController, type: :controller, with_settings: { journal_aggregation_time_minutes: 0 } do
  let(:user) { FactoryBot.create(:user) }
  let(:project) { FactoryBot.create(:project) }
  let(:role) { FactoryBot.create(:role) }
  let!(:member) do
    FactoryBot.create(:member,
                      project: project,
                      principal: user,
                      roles: [role])
  end
  let!(:forum) do
    FactoryBot.create(:forum,
                      project: project)
  end

  let(:filename) { 'testfile.txt' }
  let(:file) { File.open(Rails.root.join('spec/fixtures/files', filename)) }

  before { allow(User).to receive(:current).and_return user }

  describe '#show' do
    context 'public project' do
      let(:user) { User.anonymous }
      let(:project) { FactoryBot.create(:public_project) }
      let!(:message) { FactoryBot.create :message, forum: forum }

      it 'renders the show template' do
        get :show, params: { project_id: project.id, id: message.id }

        expect(response).to be_successful
        expect(response).to render_template 'messages/show'
        expect(assigns(:topic)).to be_present
        expect(assigns(:forum)).to be_present
        expect(assigns(:project)).to be_present
      end
    end
  end

  describe '#update' do
    let(:message) { FactoryBot.create :message, forum: forum }
    let(:other_forum) { FactoryBot.create :forum, project: project }

    before do
      role.add_permission!(:edit_messages) and user.reload
      put :update, params: { id: message,
                             message: { forum_id: other_forum } }
    end

    it 'allows for changing the board' do
      expect(message.reload.forum).to eq(other_forum)
    end

    context 'attachment upload' do
      let!(:message) { FactoryBot.create(:message) }
      let(:attachment_id) { "attachments_#{message.attachments.first.id}" }
      # Attachment is already uploaded
      let(:attachment) { FactoryBot.create(:attachment, container: nil, author: user) }
      let(:params) do
        { id: message.id,
          attachments: { '0' => { 'id' => attachment.id } } }
      end

      describe 'add' do
        before do
          allow_any_instance_of(Message).to receive(:editable_by?).and_return(true)
        end

        context 'journal' do
          before do
            put :update, params: params

            message.reload
          end

          describe '#key' do
            subject { message.journals.last.details }

            it { is_expected.to have_key attachment_id }
          end

          describe '#value' do
            subject { message.journals.last.details[attachment_id].last }

            it { is_expected.to eq(attachment.filename) }
          end
        end
      end
    end

    describe '#remove' do
      let!(:attachment) do
        FactoryBot.create(:attachment,
                          container: message,
                          author: user,
                          filename: filename)
      end
      let!(:attachable_journal) do
        FactoryBot.create(:journal_attachable_journal,
                          journal: message.journals.last,
                          attachment: attachment,
                          filename: filename)
      end

      before do
        message.reload
        message.attachments.delete(attachment)
        message.reload
      end

      context 'journal' do
        let(:attachment_id) { "attachments_#{attachment.id}" }

        describe '#key' do
          subject { message.journals.last.details }

          it { is_expected.to have_key attachment_id }
        end

        describe '#value' do
          subject { message.journals.last.details[attachment_id].first }

          it { is_expected.to eq(filename) }
        end
      end
    end
  end

  describe 'quote' do
    let(:message) { FactoryBot.create :message, content: 'foo', subject: 'subject', forum: forum }

    context 'when allowed' do
      let(:user) { FactoryBot.create(:admin) }

      before do
        login_as user
      end

      it 'renders the content as json' do
        get :quote, params: { forum_id: forum.id, id: message.id }, format: :json

        expect(response).to be_successful
        expect(response.body).to eq '{"subject":"RE: subject","content":" wrote:\n\u003e foo\n\n"}'
      end
    end
  end
end
