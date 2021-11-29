
require 'spec_helper'
require_relative '../shared_expectations'

describe CustomActions::Conditions::Status, type: :model do
  it_behaves_like 'associated custom condition' do
    let(:key) { :status }

    describe '#allowed_values' do
      it 'is the list of all status' do
        statuses = [FactoryBot.build_stubbed(:status),
                    FactoryBot.build_stubbed(:status)]
        allow(Status)
          .to receive_message_chain(:select, :order)
          .and_return(statuses)

        expect(instance.allowed_values)
          .to eql([{ value: statuses.first.id, label: statuses.first.name },
                   { value: statuses.last.id, label: statuses.last.name }])
      end
    end

    describe '#fulfilled_by?' do
      let(:work_package) { double('work_package', status_id: 1) }
      let(:user) { double('not relevant') }

      it 'is true if values are empty' do
        instance.values = []

        expect(instance.fulfilled_by?(work_package, user))
          .to be_truthy
      end

      it "is true if values include work package's status_id" do
        instance.values = [1]

        expect(instance.fulfilled_by?(work_package, user))
          .to be_truthy
      end

      it "is false if values do not include work package's status_id" do
        instance.values = [5]

        expect(instance.fulfilled_by?(work_package, user))
          .to be_falsey
      end
    end
  end
end
