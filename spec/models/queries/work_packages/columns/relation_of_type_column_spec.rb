

require 'spec_helper'
require_relative 'shared_query_column_specs'

describe Queries::WorkPackages::Columns::RelationOfTypeColumn, type: :model do
  let(:project) { FactoryBot.build_stubbed(:project) }
  let(:type) { FactoryBot.build_stubbed(:type) }
  let(:instance) { described_class.new(type) }
  let(:enterprise_token_allows) { true }

  it_behaves_like 'query column'

  describe 'instances' do
    before do
      stub_const('Relation::TYPES',
                 relation1: { name: :label_relates_to, sym_name: :label_relates_to, order: 1, sym: :relation1 },
                 relation2: { name: :label_duplicates, sym_name: :label_duplicated_by, order: 2, sym: :relation2 })

      allow(EnterpriseToken)
        .to receive(:allows_to?)
        .with(:work_package_query_relation_columns)
        .and_return(enterprise_token_allows)
    end

    context 'with a valid enterprise token' do
      it 'contains the type columns' do
        expect(described_class.instances.length)
          .to eq 2

        expect(described_class.instances[0].sym)
          .to eq :relation1

        expect(described_class.instances[1].sym)
          .to eq :relation2
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
