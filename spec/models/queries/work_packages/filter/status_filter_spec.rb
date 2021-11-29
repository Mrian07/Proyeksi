

require 'spec_helper'

describe Queries::WorkPackages::Filter::StatusFilter, type: :model do
  let(:status) { FactoryBot.build_stubbed(:status) }
  let(:status2) { FactoryBot.build_stubbed(:status) }

  it_behaves_like 'basic query filter' do
    let(:type) { :list }
    let(:class_key) { :status_id }

    describe '#available?' do
      it 'is true if any status exists' do
        allow(Status)
          .to receive(:all)
          .and_return [status]

        expect(instance).to be_available
      end

      it 'is false if no status exists' do
        allow(Status)
          .to receive(:exists?)
          .and_return false

        expect(instance).to_not be_available
      end
    end

    describe '#allowed_values' do
      before do
        allow(Status)
          .to receive(:all)
          .and_return [status]
      end

      it 'is an array of status values' do
        expect(instance.allowed_values)
          .to match_array [[status.name, status.id.to_s]]
      end
    end

    describe '#valid_values!' do
      before do
        allow(Status)
          .to receive(:all)
          .and_return [status]

        instance.values = [status.id.to_s, '99999']
      end

      it 'remove the invalid value' do
        instance.valid_values!

        expect(instance.values).to match_array [status.id.to_s]
      end
    end

    describe '#value_objects' do
      before do
        allow(Status)
          .to receive(:all)
          .and_return [status, status2]
      end

      it 'is an array of statuses' do
        instance.values = [status.id.to_s]

        expect(instance.value_objects)
          .to match_array [status]
      end
    end

    describe '#ar_object_filter?' do
      it 'is true' do
        expect(instance)
          .to be_ar_object_filter
      end
    end
  end
end
