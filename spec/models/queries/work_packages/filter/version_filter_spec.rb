

require 'spec_helper'

describe Queries::WorkPackages::Filter::VersionFilter, type: :model do
  let(:version) { FactoryBot.build_stubbed(:version) }

  it_behaves_like 'basic query filter' do
    let(:type) { :list_optional }
    let(:class_key) { :version_id }
    let(:values) { [version.id.to_s] }
    let(:name) { WorkPackage.human_attribute_name('version') }

    before do
      if project
        allow(project)
          .to receive_message_chain(:shared_versions, :pluck)
          .and_return [version.id]
      else
        allow(Version)
          .to receive_message_chain(:visible, :systemwide, :pluck)
          .and_return [version.id]
      end
    end

    describe '#valid?' do
      context 'within a project' do
        it 'is true if the value exists as a version' do
          expect(instance).to be_valid
        end

        it 'is false if the value does not exist as a version' do
          allow(project)
            .to receive_message_chain(:shared_versions, :pluck)
            .and_return []

          expect(instance).to_not be_valid
        end
      end

      context 'outside of a project' do
        let(:project) { nil }

        it 'is true if the value exists as a version' do
          expect(instance).to be_valid
        end

        it 'is false if the value does not exist as a version' do
          allow(Version)
            .to receive_message_chain(:visible, :systemwide, :pluck)
            .and_return []

          expect(instance).to_not be_valid
        end
      end
    end

    describe '#allowed_values' do
      context 'within a project' do
        before do
          expect(instance.allowed_values)
            .to match_array [[version.id.to_s, version.id.to_s]]
        end
      end

      context 'outside of a project' do
        let(:project) { nil }

        before do
          expect(instance.allowed_values)
            .to match_array [[version.id.to_s, version.id.to_s]]
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
      let(:version1) { FactoryBot.build_stubbed(:version) }
      let(:version2) { FactoryBot.build_stubbed(:version) }

      before do
        allow(project)
          .to receive(:shared_versions)
          .and_return([version1, version2])

        instance.values = [version1.id.to_s]
      end

      it 'returns an array of versions' do
        expect(instance.value_objects)
          .to match_array([version1])
      end
    end
  end
end
