

require 'spec_helper'

describe Queries::WorkPackages::Filter::PriorityFilter, type: :model do
  let(:priority) { FactoryBot.build_stubbed(:priority) }

  it_behaves_like 'basic query filter' do
    let(:type) { :list }
    let(:class_key) { :priority_id }

    describe '#available?' do
      it 'is true if any group exists' do
        allow(IssuePriority)
          .to receive_message_chain(:active, :exists?)
          .and_return true

        expect(instance).to be_available
      end

      it 'is false if no group exists' do
        allow(IssuePriority)
          .to receive_message_chain(:active, :exists?)
          .and_return false

        expect(instance).to_not be_available
      end
    end

    describe '#allowed_values' do
      before do
        allow(IssuePriority)
          .to receive(:active)
          .and_return [priority]
      end

      it 'is an array of group values' do
        expect(instance.allowed_values)
          .to match_array [[priority.name, priority.id.to_s]]
      end
    end

    describe '#ar_object_filter?' do
      it 'is true' do
        expect(instance)
          .to be_ar_object_filter
      end
    end

    describe '#value_objects' do
      let(:priority2) { FactoryBot.build_stubbed(:priority) }

      before do
        allow(IssuePriority)
          .to receive(:active)
          .and_return([priority, priority2])

        instance.values = [priority2.id.to_s]
      end

      it 'returns an array of priorities' do
        expect(instance.value_objects)
          .to match_array([priority2])
      end
    end
  end
end
