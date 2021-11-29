#-- encoding: UTF-8



require 'spec_helper'

describe Queries::Copy::FiltersMapper do
  let(:state) { ::Shared::ServiceState.new }
  let(:instance) { described_class.new(state, filters) }
  subject { instance.map_filters! }

  describe 'with a query filters array' do
    let(:query) do
      query = FactoryBot.build(:query)
      query.add_filter 'parent', '=', ['1']
      query.add_filter 'category_id', '=', ['2']
      query.add_filter 'version_id', '=', ['3']

      query
    end
    let(:filters) { query.filters }

    context 'when mapping state exists' do
      before do
        state.work_package_id_lookup = { 1 => 11 }
        state.category_id_lookup = { 2 => 22 }
        state.version_id_lookup = { 3 => 33 }
      end

      it 'maps the filters' do
        expect(subject[1].values).to eq(['11'])
        expect(subject[2].values).to eq(['22'])
        expect(subject[3].values).to eq(['33'])
      end
    end

    context 'when mapping state does not exist' do
      it 'does not map the filters' do
        expect(subject[1].values).to eq(['1'])
        expect(subject[2].values).to eq(['2'])
        expect(subject[3].values).to eq(['3'])
      end
    end
  end

  describe 'with a filter hash array' do
    let(:filters) do
      [
        { 'parent' => { 'operator' => '=', 'values' => ['1'] } },
        { 'category_id' => { 'operator' => '=', 'values' => ['2'] } },
        { 'version_id' => { 'operator' => '=', 'values' => ['3'] } }
      ]
    end

    context 'when mapping state exists' do
      before do
        state.work_package_id_lookup = { 1 => 11 }
        state.category_id_lookup = { 2 => 22 }
        state.version_id_lookup = { 3 => 33 }
      end

      it 'maps the filters' do
        expect(subject[0]['parent']['values']).to eq(['11'])
        expect(subject[1]['category_id']['values']).to eq(['22'])
        expect(subject[2]['version_id']['values']).to eq(['33'])
      end
    end

    context 'when mapping state does not exist' do
      it 'does not map the filters' do
        expect(subject[0]['parent']['values']).to eq(['1'])
        expect(subject[1]['category_id']['values']).to eq(['2'])
        expect(subject[2]['version_id']['values']).to eq(['3'])
      end
    end
  end
end
