

require 'spec_helper'

describe Queries::WorkPackages::Filter::GroupFilter, type: :model do
  let(:group) { FactoryBot.build_stubbed(:group) }

  it_behaves_like 'basic query filter' do
    let(:type) { :list_optional }
    let(:class_key) { :member_of_group }
    let(:name) { I18n.t('query_fields.member_of_group') }

    describe '#available?' do
      it 'is true if any group exists' do
        allow(Group)
          .to receive(:exists?)
          .and_return true

        expect(instance).to be_available
      end

      it 'is false if no group exists' do
        allow(Group)
          .to receive(:exists?)
          .and_return false

        expect(instance).to_not be_available
      end
    end

    describe '#allowed_values' do
      before do
        allow(Group)
          .to receive(:all)
          .and_return [group]
      end

      it 'is an array of group values' do
        expect(instance.allowed_values)
          .to match_array [[group.name, group.id.to_s]]
      end
    end

    describe '#ar_object_filter?' do
      it 'is true' do
        expect(instance)
          .to be_ar_object_filter
      end
    end

    describe '#value_objects' do
      let(:group2) { FactoryBot.build_stubbed(:group) }

      before do
        allow(Group)
          .to receive(:all)
          .and_return([group, group2])

        instance.values = [group2.id.to_s]
      end

      it 'returns an array of groups' do
        expect(instance.value_objects)
          .to match_array([group2])
      end
    end
  end
end
