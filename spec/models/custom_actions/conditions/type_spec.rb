
require 'spec_helper'
require_relative '../shared_expectations'

describe CustomActions::Conditions::Type, type: :model do
  it_behaves_like 'associated custom condition' do
    let(:key) { :type }

    describe '#allowed_values' do
      it 'is the list of all types' do
        types = [FactoryBot.build_stubbed(:type),
                 FactoryBot.build_stubbed(:type)]
        allow(Type)
          .to receive_message_chain(:select)
          .and_return(types)

        expect(instance.allowed_values)
          .to eql([{ value: types.first.id, label: types.first.name },
                   { value: types.last.id, label: types.last.name }])
      end
    end

    describe '#fulfilled_by?' do
      let(:work_package) { double('work_package', type_id: 1) }
      let(:user) { double('not relevant') }

      it 'is true if values are empty' do
        instance.values = []

        expect(instance.fulfilled_by?(work_package, user))
          .to be_truthy
      end

      it "is true if values include work package's type_id" do
        instance.values = [1]

        expect(instance.fulfilled_by?(work_package, user))
          .to be_truthy
      end

      it "is false if values do not include work package's type_id" do
        instance.values = [5]

        expect(instance.fulfilled_by?(work_package, user))
          .to be_falsey
      end
    end
  end
end
