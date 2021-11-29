
require 'spec_helper'
require_relative '../shared_expectations'

describe CustomActions::Actions::Type, type: :model do
  let(:key) { :type }
  let(:priority) { 20 }
  let(:type) { :associated_property }
  let(:allowed_values) do
    types = [FactoryBot.build_stubbed(:type),
             FactoryBot.build_stubbed(:type)]
    allow(Type)
      .to receive_message_chain(:select, :order)
            .and_return(types)

    [{ value: types.first.id, label: types.first.name },
     { value: types.last.id, label: types.last.name }]
  end

  it_behaves_like 'base custom action'
  it_behaves_like 'associated custom action' do
    describe '#allowed_values' do
      it 'is the list of all type' do
        allowed_values

        expect(instance.allowed_values)
          .to eql(allowed_values)
      end
    end
  end
end
