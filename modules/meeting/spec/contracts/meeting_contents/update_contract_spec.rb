#-- encoding: UTF-8



require 'spec_helper'
require 'contracts/shared/model_contract_shared_context'

describe MeetingContents::UpdateContract do
  include_context 'ModelContract shared context'
  let(:agenda) { FactoryBot.build_stubbed(:meeting_agenda) }
  let(:current_user) { FactoryBot.build_stubbed(:user) }
  let(:contract) { described_class.new(agenda, current_user) }

  context 'when not editable' do
    before do
      allow(agenda).to receive(:editable?).and_return false
    end

    it_behaves_like 'contract is invalid', base: :error_readonly
  end

  context 'when editable' do
    before do
      allow(agenda).to receive(:editable?).and_return true
    end

    it_behaves_like 'contract is valid'
  end
end
