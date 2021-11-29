
require 'spec_helper'
require_relative '../shared_expectations'

describe CustomActions::Actions::Status, type: :model do
  let(:key) { :status }
  let(:type) { :associated_property }
  let(:allowed_values) do
    statuses = [FactoryBot.build_stubbed(:status),
                FactoryBot.build_stubbed(:status)]
    allow(Status)
      .to receive_message_chain(:select, :order)
            .and_return(statuses)

    [{ value: statuses.first.id, label: statuses.first.name },
     { value: statuses.last.id, label: statuses.last.name }]
  end

  it_behaves_like 'base custom action'
  it_behaves_like 'associated custom action' do
    describe '#allowed_values' do
      it 'is the list of all status' do
        allowed_values

        expect(instance.allowed_values)
          .to eql(allowed_values)
      end
    end
  end
end
