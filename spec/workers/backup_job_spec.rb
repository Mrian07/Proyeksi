

require 'spec_helper'

describe BackupJob, type: :model do
  shared_examples "it creates a backup" do |opts = {}|
    let(:job) { BackupJob.new }

    let(:previous_backup) { FactoryBot.create :backup }
    let(:backup) { FactoryBot.create :backup }
    let(:status) { :in_queue }
    let(:job_id) { 42 }

    let(:job_status) do
      FactoryBot.create(
        :delayed_job_status,
        user: user,
        reference: backup,
        status: JobStatus::Status.statuses[status],
        job_id: job_id
      )
    end

    let(:db_dump_process_status) do
      success = db_dump_success

      Object.new.tap do |o|
        o.define_singleton_method(:success?) { success }
      end
    end

    let(:db_dump_success) { false }

    let(:arguments) { [{ backup: backup, user: user, **opts }] }

    let(:user) { FactoryBot.create :admin }

    before do
      previous_backup; backup; status # create

      allow(job).to receive(:arguments).and_return arguments
      allow(job).to receive(:job_id).and_return job_id

      expect(Open3).to receive(:capture3).and_return [nil, "Dump failed", db_dump_process_status]

      allow_any_instance_of(BackupJob)
        .to receive(:tmp_file_name).with("proyeksiapp", ".sql").and_return("/tmp/proyeksiapp.sql")

      allow_any_instance_of(BackupJob)
        .to receive(:tmp_file_name).with("proyeksiapp-backup", ".zip").and_return("/tmp/proyeksiapp.zip")

      allow(File).to receive(:read).and_call_original
      allow(File).to receive(:read).with("/tmp/proyeksiapp.sql").and_return "SOME SQL"
    end

    def perform
      job.perform **arguments.first
    end

    context "with a failed database dump" do
      let(:db_dump_success) { false }

      before { perform }

      it "retains previous backups" do
        expect(Backup.find_by(id: previous_backup.id)).not_to be_nil
      end
    end

    context "with a successful database dump" do
      let(:db_dump_success) { true }

      let!(:attachment) { FactoryBot.create :attachment }
      let!(:pending_direct_upload) { FactoryBot.create :pending_direct_upload }
      let(:stored_backup) { Attachment.where(container_type: "Export").last }
      let(:backup_files) { Zip::File.open(stored_backup.file.path) { |zip| zip.entries.map(&:name) } }

      def backed_up_attachment(attachment)
        "attachment/file/#{attachment.id}/#{attachment.filename}"
      end

      before { perform }

      it "destroys any previous backups" do
        expect(Backup.find_by(id: previous_backup.id)).to be_nil
      end

      it "stores a new backup as an attachment" do
        expect(stored_backup.filename).to eq "proyeksiapp.zip"
      end

      it "includes the database dump in the backup" do
        expect(backup_files).to include "proyeksiapp.sql"
      end

      if opts[:include_attachments] != false
        it "includes attachments in the backup" do
          expect(backup_files).to include backed_up_attachment(attachment)
        end

        it "does not include pending direct uploads" do
          expect(backup_files).not_to include backed_up_attachment(pending_direct_upload)
        end
      else
        it "does not include attachments in the backup" do
          expect(backup_files).not_to include backed_up_attachment(attachment)
          expect(backup_files).not_to include backed_up_attachment(pending_direct_upload)
        end
      end
    end
  end

  context "per default" do
    it_behaves_like "it creates a backup"
  end

  context "with include_attachments: false" do
    it_behaves_like "it creates a backup", include_attachments: false
  end
end
