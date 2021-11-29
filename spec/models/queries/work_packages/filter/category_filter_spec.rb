

require 'spec_helper'

describe Queries::WorkPackages::Filter::CategoryFilter, type: :model do
  it_behaves_like 'basic query filter' do
    let(:type) { :list_optional }
    let(:class_key) { :category_id }

    describe '#available?' do
      context 'within a project' do
        before do
          allow(project)
            .to receive_message_chain(:categories, :exists?)
            .and_return true
        end

        it 'is true' do
          expect(instance).to be_available
        end

        it 'is false without a type' do
          allow(project)
            .to receive_message_chain(:categories, :exists?)
            .and_return false

          expect(instance).to_not be_available
        end
      end

      context 'without a project' do
        let(:project) { nil }

        it 'is false' do
          expect(instance).to_not be_available
        end
      end
    end

    describe '#allowed_values' do
      let(:category) { FactoryBot.build_stubbed(:category) }

      before do
        allow(project)
          .to receive(:categories)
          .and_return [category]
      end

      it 'returns an array of type options' do
        expect(instance.allowed_values)
          .to match_array [[category.name, category.id.to_s]]
      end
    end

    describe '#value_objects' do
      let(:category1) { FactoryBot.build_stubbed(:category) }
      let(:category2) { FactoryBot.build_stubbed(:category) }

      before do
        allow(project)
          .to receive(:categories)
          .and_return [category1, category2]

        instance.values = [category2.id.to_s]
      end

      it 'returns an array of category' do
        expect(instance.value_objects)
          .to match_array [category2]
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
