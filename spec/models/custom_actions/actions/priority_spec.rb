
require 'spec_helper'
require_relative '../shared_expectations'

describe CustomActions::Actions::Priority, type: :model do
  let(:key) { :priority }
  let(:type) { :associated_property }
  let(:allowed_values) do
    priorities = [FactoryBot.build_stubbed(:issue_priority),
                  FactoryBot.build_stubbed(:issue_priority)]
    allow(IssuePriority)
      .to receive_message_chain(:select, :order)
            .and_return(priorities)

    [{ value: priorities.first.id, label: priorities.first.name },
     { value: priorities.last.id, label: priorities.last.name }]
  end

  it_behaves_like 'base custom action'
  it_behaves_like 'associated custom action' do
    describe '#allowed_values' do
      it 'is the list of all priorities' do
        allowed_values

        expect(instance.allowed_values)
          .to eql(allowed_values)
      end
    end
  end
end
