#-- encoding: UTF-8



require 'spec_helper'

describe Notifications::GroupMemberAlteredJob, type: :model do
  subject(:service_call) do
    described_class.new.perform(members_ids, message)
  end
  let(:time) { Time.now }
  let(:member1) do
    FactoryBot.build_stubbed(:member, updated_at: time, created_at: time)
  end
  let(:member2) do
    FactoryBot.build_stubbed(:member, updated_at: time + 1.second, created_at: time)
  end
  let(:members) { [member1, member2] }
  let(:members_ids) { members.map(&:id) }
  let(:message) { "Some message" }

  before do
    allow(ProyeksiApp::Notifications)
      .to receive(:send)

    allow(Member)
      .to receive(:where)
      .with(id: members_ids)
      .and_return(members)
  end

  it 'sends a created notification for the membership with the matching timestamps' do
    service_call

    expect(ProyeksiApp::Notifications)
      .to have_received(:send)
      .with(ProyeksiApp::Events::MEMBER_CREATED, member: member1, message: message)
  end

  it 'sends an updated notification for the membership with the mismatching timestamps' do
    service_call

    expect(ProyeksiApp::Notifications)
      .to have_received(:send)
      .with(ProyeksiApp::Events::MEMBER_UPDATED, member: member2, message: message)
  end
end
