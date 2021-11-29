

require 'spec_helper'

describe Queries::Relations::RelationQuery, type: :model do
  let(:instance) { described_class.new }
  let(:base_scope) { Relation.direct.order(id: :desc) }

  context 'without a filter' do
    describe '#results' do
      it 'is the same as getting all the relations' do
        expect(instance.results.to_sql).to eql base_scope.visible.to_sql
      end
    end

    describe '#valid?' do
      it 'is true' do
        expect(instance).to be_valid
      end
    end
  end

  context 'with a type filter' do
    before do
      instance.where('type', '=', ['follows', 'blocks'])
    end

    describe '#results' do
      it 'is the same as handwriting the query' do
        expected = base_scope
                   .merge(Relation
                          .where("relations.follows IN ('1') OR relations.blocks IN ('1')"))
                   .visible

        expect(instance.results.to_sql).to eql expected.to_sql
      end
    end

    describe '#valid?' do
      it 'is true' do
        expect(instance).to be_valid
      end

      it 'is invalid if the filter is invalid' do
        instance.where('type', '=', [''])

        expect(instance).to be_invalid
      end
    end
  end

  context 'with a from filter' do
    let(:current_user) { FactoryBot.build_stubbed(:user) }
    before do
      login_as(current_user)
      instance.where('from_id', '=', ['1'])
    end

    describe '#results' do
      it 'is the same as handwriting the query (with visibility checked within the filter query)' do
        visible_sql = WorkPackage.visible(current_user).select(:id).to_sql

        expected = base_scope
                   .merge(Relation
                          .where("from_id IN ('1') AND to_id IN (#{visible_sql})"))

        expect(instance.results.to_sql).to eql expected.to_sql
      end
    end
  end

  context 'with an order by id asc' do
    describe '#results' do
      it 'returns all visible relations ordered by id asc' do
        expect(instance.order(id: :asc).results.to_sql)
          .to eql base_scope.visible.except(:order).order(id: :asc).to_sql
      end
    end
  end
end
