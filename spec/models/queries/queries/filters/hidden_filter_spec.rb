#-- encoding: UTF-8



require 'spec_helper'

describe Queries::Queries::Filters::HiddenFilter, type: :model do
  let(:instance) do
    described_class.create!(name: 'hidden', context: nil, operator: operator, values: values)
  end

  it_behaves_like 'basic query filter' do
    let(:class_key) { :hidden }
    let(:type) { :list }
  end

  include_context 'filter tests'
  let(:type) { :list }

  describe '#scope' do
    context 'for "= t"' do
      let(:operator) { '=' }
      let(:values) { ['t'] }

      it 'is the same as handwriting the query' do
        expected = Query.where(["queries.hidden IN (?)", values])

        expect(instance.scope.to_sql).to eql expected.to_sql
      end
    end

    context 'for "= f"' do
      let(:operator) { '=' }
      let(:values) { ['f'] }

      it 'is the same as handwriting the query' do
        sql = "queries.hidden IS NULL OR queries.hidden IN (?)"
        expected = Query.where([sql, values])

        expect(instance.scope.to_sql).to eql expected.to_sql
      end
    end

    context 'for "!"' do
      let(:operator) { '!' }
      let(:values) { ['f'] }

      it 'is the same as handwriting the query' do
        expected = Query.where(["queries.hidden IN ('t')", values])

        expect(instance.scope.to_sql).to eql expected.to_sql
      end
    end
  end

  describe '#valid?' do
    let(:operator) { '=' }

    context 'for true value' do
      let(:values) { ['t'] }

      it 'is valid' do
        expect(instance).to be_valid
      end
    end

    context 'for false value' do
      let(:values) { ['f'] }

      it 'is valid' do
        expect(instance).to be_valid
      end
    end

    context 'for an invalid operator' do
      let(:operator) { '*' }

      it 'is invalid' do
        expect(instance).to be_invalid
      end
    end

    context 'for an invalid value' do
      let(:values) { ['inexistent'] }

      it 'is invalid' do
        expect(instance).to be_invalid
      end
    end
  end
end
