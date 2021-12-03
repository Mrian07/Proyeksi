#-- encoding: UTF-8



require 'spec_helper'

describe Attachments::CleanupUncontaineredJob, type: :job do
  let(:grace_period) { 120 }

  let!(:containered_attachment) { FactoryBot.create(:attachment) }
  let!(:old_uncontainered_attachment) do
    FactoryBot.create(:attachment, container: nil, created_at: Time.now - grace_period.minutes)
  end
  let!(:new_uncontainered_attachment) do
    FactoryBot.create(:attachment, container: nil, created_at: Time.now - (grace_period - 1).minutes)
  end

  let!(:finished_upload) do
    FactoryBot.create(:attachment, created_at: Time.now - grace_period.minutes, digest: "0x42")
  end
  let!(:old_pending_upload) do
    FactoryBot.create(:attachment, created_at: Time.now - grace_period.minutes, digest: "", downloads: -1)
  end
  let!(:new_pending_upload) do
    FactoryBot.create(:attachment, created_at: Time.now - (grace_period - 1).minutes, digest: "", downloads: -1)
  end

  let(:job) { described_class.new }

  before do
    allow(ProyeksiApp::Configuration)
      .to receive(:attachments_grace_period)
      .and_return(grace_period)
  end

  it 'removes all uncontainered attachments and pending uploads that are older than the grace period' do
    job.perform

    expect(Attachment.all)
      .to match_array([containered_attachment, new_uncontainered_attachment, finished_upload, new_pending_upload])
  end
end
