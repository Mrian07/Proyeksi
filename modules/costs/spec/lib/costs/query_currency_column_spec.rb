

require 'spec_helper'

describe Costs::QueryCurrencyColumn, type: :model do
  let(:project) do
    FactoryBot.build_stubbed(:project).tap do |p|
      allow(p)
        .to receive(:costs_enabled?)
        .and_return(costs_enabled)
    end
  end
  let(:instance) { described_class.instances(project).detect { |c| c.name == column_name } }
  let(:costs_enabled) { true }
  let(:column_name) { :material_costs }

  describe '.instances' do
    subject { described_class.instances(project).map(&:name) }

    context 'with costs enabled' do
      it 'returns the four costs columns' do
        is_expected
          .to match_array %i[budget material_costs labor_costs overall_costs]
      end
    end

    context 'with costs disabled' do
      let(:costs_enabled) { false }

      it 'returns no columns' do
        is_expected
          .to be_empty
      end
    end

    context 'with no context' do
      it 'returns the four costs columns' do
        is_expected
          .to match_array %i[budget material_costs labor_costs overall_costs]
      end
    end
  end

  context 'material_costs' do
    describe '#summable?' do
      it 'is true' do
        expect(instance)
          .to be_summable
      end
    end

    describe '#summable' do
      it 'is callable' do
        expect(instance.summable)
          .to respond_to(:call)
      end

      # Not testing the results here, this is done by an integration test
      it 'returns an AR scope that has an id and a material_costs column' do
        query = double('query')
        result = double('result')

        allow(query)
          .to receive(:results)
          .and_return result

        allow(result)
          .to receive(:work_packages)
          .and_return(WorkPackage.all)

        allow(query)
          .to receive(:group_by_statement)
          .and_return('author_id')

        expect(ActiveRecord::Base.connection.select_all(instance.summable.(query, true).to_sql).columns)
          .to match_array %w(id material_costs)
      end
    end
  end

  context 'labor_costs' do
    let(:column_name) { :labor_costs }

    describe '#summable?' do
      it 'is true' do
        expect(instance)
          .to be_summable
      end
    end

    describe '#summable' do
      it 'is callable' do
        expect(instance.summable)
          .to respond_to(:call)
      end

      # Not testing the results here, this is done by an integration test
      it 'returns an AR scope that has an id and a labor_costs column' do
        query = double('query')
        result = double('result')

        allow(query)
          .to receive(:results)
          .and_return result

        allow(result)
          .to receive(:work_packages)
          .and_return(WorkPackage.all)

        allow(query)
          .to receive(:group_by_statement)
          .and_return('author_id')

        expect(ActiveRecord::Base.connection.select_all(instance.summable.(query, true).to_sql).columns)
          .to match_array %w(id labor_costs)
      end
    end
  end
end
