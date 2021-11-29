

require 'spec_helper'

describe Attachments::CreateService, 'integration', with_settings: { journal_aggregation_time_minutes: 0 } do
  let(:description) { 'a fancy description' }

  subject { described_class.new(user: user) }

  describe '#call' do
    def call_tested_method
      subject.call container: container,
                   file: FileHelpers.mock_uploaded_file(name: 'foobar.txt'),
                   filename: 'foobar.txt',
                   description: description
    end

    context 'when journalized' do
      shared_let(:container) { FactoryBot.create(:work_package) }
      shared_let(:user) do
        FactoryBot.create :user,
                          member_in_project: container.project,
                          member_with_permissions: %i[view_work_packages edit_work_packages]
      end

      shared_examples 'successful creation' do
        it 'saves the attachment' do
          attachment = Attachment.first
          expect(attachment.filename).to eq 'foobar.txt'
          expect(attachment.description).to eq description
        end

        it 'adds the attachment to the container' do
          container.reload
          expect(container.attachments).to include Attachment.first
        end

        it 'adds a journal entry on the container' do
          expect(container.journals.count).to eq 2 # 1 for WP creation + 1 for the attachment
        end

        it 'updates the timestamp on the container' do
          expect(container.reload.updated_at)
            .not_to eql timestamp_before
        end
      end

      context 'with a valid container' do
        let!(:timestamp_before) { container.updated_at }

        before do
          call_tested_method
        end

        it_behaves_like 'successful creation'
      end

      context "with an invalid container" do
        let!(:timestamp_before) { container.updated_at }

        before do
          # have an invalid work package
          container.update_column(:subject, '')

          call_tested_method
        end

        it_behaves_like 'successful creation'
      end

      context 'with an invalid attachment', with_settings: { attachment_max_size: 0 } do
        it 'does not raise exceptions' do
          expect { call_tested_method }
            .not_to raise_exception ActiveRecord::RecordInvalid

          expect(call_tested_method.errors[:file]).to include "is too large (maximum size is 0 Bytes)."
        end
      end
    end

    context 'when not journalized' do
      shared_let(:container) { FactoryBot.create(:message) }
      shared_let(:user) do
        FactoryBot.create :user,
                          member_in_project: container.forum.project,
                          member_with_permissions: %i[add_messages edit_messages]
      end

      shared_examples 'successful creation' do
        it 'saves the attachment' do
          attachment = Attachment.first
          expect(attachment.filename).to eq 'foobar.txt'
          expect(attachment.description).to eq description
        end

        it 'adds the attachment to the container' do
          container.reload
          expect(container.attachments).to include Attachment.first
        end

        it 'adds a journal entry on the container' do
          expect(container.journals.count).to eq 2 # 1 for WP creation + 1 for the attachment
        end

        it 'updates the timestamp on the container' do
          expect(container.reload.updated_at)
            .not_to eql timestamp_before
        end
      end

      context 'with a valid container' do
        let!(:timestamp_before) { container.updated_at }

        before do
          call_tested_method
        end

        it_behaves_like 'successful creation'
      end

      context "with an invalid container" do
        let!(:timestamp_before) { container.updated_at }

        before do
          container.update_column(:subject, '')

          call_tested_method
        end

        it_behaves_like 'successful creation'
      end
    end

    context "when uncontainered" do
      let(:container) { nil }
      let(:user) { FactoryBot.create :admin }

      before do
        call_tested_method
      end

      it 'saves the attachment' do
        attachment = Attachment.first
        expect(attachment.filename).to eq 'foobar.txt'
        expect(attachment.description).to eq description
      end
    end

    context "when user with no permissions" do
      let(:container) { nil }
      let(:user) { FactoryBot.build_stubbed :user }

      it 'does not save an attachment' do
        expect do
          expect(call_tested_method).to be_failure
          expect(call_tested_method.errors[:base]).to include 'may not be accessed.'
        end.not_to change { Attachment.count }
      end
    end
  end
end
