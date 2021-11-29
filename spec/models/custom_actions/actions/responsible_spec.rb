
require 'spec_helper'
require_relative '../shared_expectations'

describe CustomActions::Actions::Responsible, type: :model do
  let(:key) { :responsible }
  let(:type) { :associated_property }
  let(:allowed_values) do
    principals = [FactoryBot.build_stubbed(:user),
                  FactoryBot.build_stubbed(:group)]

    allow(User)
      .to receive_message_chain(:not_locked, :select, :ordered_by_name)
            .and_return(principals)

    [{ value: nil, label: '-' },
     { value: principals.first.id, label: principals.first.name },
     { value: principals.last.id, label: principals.last.name }]
  end

  it_behaves_like 'base custom action'
  it_behaves_like 'associated custom action' do
    describe '#allowed_values' do
      it 'is the list of all users and groups' do
        allowed_values

        expect(instance.allowed_values)
          .to eql(allowed_values)
      end
    end
  end
end
