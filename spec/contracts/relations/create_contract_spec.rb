#-- encoding: UTF-8



require 'spec_helper'

describe Relations::CreateContract do
  let(:from) { FactoryBot.build_stubbed :work_package }
  let(:to) { FactoryBot.build_stubbed :work_package }
  let(:user) { FactoryBot.build_stubbed :admin }

  let(:relation) do
    Relation.new from: from, to: to, relation_type: "follows", delay: 42
  end

  subject(:contract) { described_class.new relation, user }

  before do
    allow(WorkPackage)
      .to receive_message_chain(:visible, :exists?)
      .and_return(true)
  end

  describe 'to' do
    context 'not visible' do
      before do
        allow(WorkPackage)
          .to receive_message_chain(:visible, :exists?)
          .with(to.id)
          .and_return(false)
      end

      it 'is invalid' do
        is_expected.not_to be_valid
      end
    end
  end

  describe 'from' do
    context 'not visible' do
      before do
        allow(WorkPackage)
          .to receive_message_chain(:visible, :exists?)
          .with(from.id)
          .and_return(false)
      end

      it 'is invalid' do
        is_expected.not_to be_valid
      end
    end
  end
end
