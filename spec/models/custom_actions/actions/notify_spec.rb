
require 'spec_helper'
require_relative '../shared_expectations'

describe CustomActions::Actions::Notify, type: :model do
  let(:key) { :notify }
  let(:type) { :associated_property }
  let(:allowed_values) do
    users = [FactoryBot.build_stubbed(:user),
             FactoryBot.build_stubbed(:group)]

    allow(Principal)
      .to receive_message_chain(:not_locked, :select, :ordered_by_name)
            .and_return(users)

    [{ value: nil, label: '-' },
     { value: users.first.id, label: users.first.name },
     { value: users.last.id, label: users.last.name }]
  end

  it_behaves_like 'base custom action' do
    describe '#allowed_values' do
      it 'is the list of all users' do
        allowed_values

        expect(instance.allowed_values)
          .to eql(allowed_values)
      end
    end

    it_behaves_like 'associated custom action validations'

    describe '#apply' do
      let(:work_package) { FactoryBot.build_stubbed(:stubbed_work_package) }

      it 'adds a note with all values distinguised by type' do
        principals = [FactoryBot.build_stubbed(:user),
                      FactoryBot.build_stubbed(:group),
                      FactoryBot.build_stubbed(:user)]

        allow(Principal)
          .to receive_message_chain(:not_locked, :select, :ordered_by_name, :where)
          .and_return(principals)

        instance.values = principals.map(&:id)

        expect(work_package)
          .to receive(:journal_notes=)
          .with("user##{principals[0].id}, group##{principals[1].id}, user##{principals[2].id}")

        instance.apply(work_package)
      end
    end

    describe '#multi_value?' do
      it 'is true' do
        expect(instance)
          .to be_multi_value
      end
    end
  end
end
