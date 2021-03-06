

require 'spec_helper'

describe Queries::WorkPackages::Filter::TypeFilter, type: :model do
  it_behaves_like 'basic query filter' do
    let(:type) { :list }
    let(:class_key) { :type_id }

    describe '#available?' do
      context 'within a project' do
        before do
          allow(project)
            .to receive_message_chain(:rolled_up_types, :exists?)
            .and_return true
        end

        it 'is true' do
          expect(instance).to be_available
        end

        it 'is false without a type' do
          allow(project)
            .to receive_message_chain(:rolled_up_types, :exists?)
            .and_return false

          expect(instance).to_not be_available
        end
      end

      context 'without a project' do
        let(:project) { nil }

        before do
          allow(Type)
            .to receive_message_chain(:order, :exists?)
            .and_return true
        end

        it 'is true' do
          expect(instance).to be_available
        end

        it 'is false without a type' do
          allow(Type)
            .to receive_message_chain(:order, :exists?)
            .and_return false

          expect(instance).to_not be_available
        end
      end
    end

    describe '#allowed_values' do
      let(:type) { FactoryBot.build_stubbed(:type) }
      context 'within a project' do
        before do
          allow(project)
            .to receive(:rolled_up_types)
            .and_return [type]
        end

        it 'returns an array of type options' do
          expect(instance.allowed_values)
            .to match_array [[type.name, type.id.to_s]]
        end
      end

      context 'without a project' do
        let(:project) { nil }

        before do
          allow(Type)
            .to receive_message_chain(:order)
            .and_return [type]
        end

        it 'returns an array of type options' do
          expect(instance.allowed_values)
            .to match_array [[type.name, type.id.to_s]]
        end
      end
    end

    describe '#ar_object_filter?' do
      it 'is true' do
        expect(instance)
          .to be_ar_object_filter
      end
    end

    describe '#value_objects' do
      let(:type1) { FactoryBot.build_stubbed(:type) }
      let(:type2) { FactoryBot.build_stubbed(:type) }

      before do
        allow(project)
          .to receive(:rolled_up_types)
          .and_return([type1, type2])

        instance.values = [type1.id.to_s, type2.id.to_s]
      end

      it 'returns an array of types' do
        expect(instance.value_objects)
          .to match_array([type1, type2])
      end
    end
  end
end
