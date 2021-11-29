

require 'spec_helper'

describe Queries::Queries::QueryQuery, type: :model do
  let(:user) { FactoryBot.build_stubbed(:user) }
  let(:instance) { described_class.new(user: user) }
  let(:base_scope) { Query.visible(to: user).order(id: :desc) }

  context 'without a filter' do
    describe '#results' do
      it 'is the same as getting all visible queries' do
        expect(instance.results.to_sql).to eql base_scope.to_sql
      end
    end
  end

  context 'with an updated_at filter' do
    before do
      instance.where('updated_at', '<>d', ['2018-03-22 20:00:00'])
    end

    describe '#results' do
      it 'is the same as handwriting the query' do
        expected = base_scope.merge(Query.where("queries.updated_at >= '2018-03-22 20:00:00'"))

        expect(instance.results.to_sql).to eql expected.to_sql
      end
    end
  end

  context 'with a project filter' do
    before do
      instance.where('project_id', '=', ['1', '2'])
    end

    describe '#results' do
      it 'is the same as handwriting the query' do
        # apparently, strings are accepted to be compared to
        # integers in the postgresql
        expected = base_scope
                   .merge(Query.where("queries.project_id IN ('1','2')"))

        expect(instance.results.to_sql).to eql expected.to_sql
      end
    end

    describe '#valid?' do
      it 'is true' do
        expect(instance).to be_valid
      end

      it 'is invalid if the filter is invalid' do
        instance.where('name', '=', [''])
        expect(instance).to be_invalid
      end
    end
  end
end
