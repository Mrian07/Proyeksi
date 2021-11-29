

require 'spec_helper'
require_relative 'shared_query_column_specs'

describe Queries::WorkPackages::Columns::CustomFieldColumn, type: :model do
  let(:project) { FactoryBot.build_stubbed(:project) }
  let(:custom_field) do
    double('CustomField',
           field_format: 'string',
           id: 5,
           order_statements: nil)
  end
  let(:instance) { described_class.new(custom_field) }

  it_behaves_like 'query column'

  describe 'instances' do
    let(:text_custom_field) do
      FactoryBot.create(:text_wp_custom_field)
    end

    let(:list_custom_field) do
      FactoryBot.create(:list_wp_custom_field)
    end

    context 'within project' do
      before do
        allow(project)
          .to receive(:all_work_package_custom_fields)
          .and_return([text_custom_field,
                       list_custom_field])
      end

      it 'contains only non text cf columns' do
        expect(described_class.instances(project).length)
          .to eq 1

        expect(described_class.instances(project)[0].custom_field)
          .to eq list_custom_field
      end
    end

    context 'global' do
      before do
        allow(WorkPackageCustomField)
          .to receive(:all)
          .and_return([text_custom_field,
                       list_custom_field])
      end

      it 'contains only non text cf columns' do
        expect(described_class.instances.length)
          .to eq 1

        expect(described_class.instances[0].custom_field)
          .to eq list_custom_field
      end
    end
  end

  describe '#value' do
    let(:mock) { double(WorkPackage) }

    it 'delegates to formatted_custom_value_for' do
      expect(mock).to receive(:formatted_custom_value_for).with(custom_field.id)
      instance.value(mock)
    end
  end
end
