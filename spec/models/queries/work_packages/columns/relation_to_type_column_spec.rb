

require 'spec_helper'
require_relative 'shared_query_column_specs'

describe Queries::WorkPackages::Columns::RelationToTypeColumn, type: :model do
  let(:project) { FactoryBot.build_stubbed(:project) }
  let(:type) { FactoryBot.build_stubbed(:type) }
  let(:instance) { described_class.new(type) }
  let(:enterprise_token_allows) { true }

  it_behaves_like 'query column'

  describe 'instances' do
    before do
      allow(EnterpriseToken)
        .to receive(:allows_to?)
        .with(:work_package_query_relation_columns)
        .and_return(enterprise_token_allows)
    end

    context 'within project' do
      before do
        allow(project)
          .to receive(:types)
          .and_return([type])
      end

      context 'with a valid enterprise token' do
        it 'contains the type columns' do
          expect(described_class.instances(project).length)
            .to eq 1

          expect(described_class.instances(project)[0].type)
            .to eq type
        end
      end

      context 'without a valid enterprise token' do
        let(:enterprise_token_allows) { false }

        it 'is empty' do
          expect(described_class.instances)
            .to be_empty
        end
      end
    end

    context 'global' do
      before do
        allow(Type)
          .to receive(:all)
          .and_return([type])
      end

      context 'with a valid enterprise token' do
        it 'contains the type columns' do
          expect(described_class.instances.length)
            .to eq 1

          expect(described_class.instances[0].type)
            .to eq type
        end
      end

      context 'without a valid enterprise token' do
        let(:enterprise_token_allows) { false }

        it 'is empty' do
          expect(described_class.instances)
            .to be_empty
        end
      end
    end
  end
end
