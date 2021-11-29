#-- encoding: UTF-8



require 'spec_helper'
require 'services/base_services/behaves_like_create_service'

describe Backups::CreateService, type: :model do
  let(:user) { FactoryBot.create :admin }
  let(:service) { described_class.new user: user, backup_token: backup_token.plain_value }
  let(:backup_token) { FactoryBot.create :backup_token, user: user }

  it_behaves_like 'BaseServices create service' do
    let(:instance) { service }
    let(:contract_options) { { backup_token: backup_token.plain_value } }
  end

  context "with right permissions" do
    context "with no further options" do
      it "enqueues a BackupJob which includes attachments" do
        expect { service.call }.to have_enqueued_job(BackupJob).with do |args|
          expect(args["include_attachments"]).to eq true
        end
      end
    end

    context "with include_attachments: false" do
      let(:service) do
        described_class.new user: user, backup_token: backup_token.plain_value, include_attachments: false
      end

      it "enqueues a BackupJob which does not include attachments" do
        expect(BackupJob)
          .to receive(:perform_later)
          .with(hash_including(include_attachments: false, user: user))

        expect(service.call).to be_success
      end
    end
  end

  context "with missing permission" do
    let(:user) { FactoryBot.create :user }

    it "does not enqueue a BackupJob" do
      expect { expect(service.call).to be_failure }.not_to have_enqueued_job(BackupJob)
    end
  end
end
