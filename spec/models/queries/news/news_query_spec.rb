

require 'spec_helper'

describe Queries::News::NewsQuery, type: :model do
  let(:user) { FactoryBot.build_stubbed(:user) }
  let(:base_scope) { News.visible(user).order(id: :desc) }
  let(:instance) { described_class.new }

  before do
    login_as(user)
  end

  context 'without a filter' do
    describe '#results' do
      it 'is the same as getting all the visible news' do
        expect(instance.results.to_sql).to eql base_scope.to_sql
      end
    end
  end

  context 'with a project filter' do
    before do
      allow(Project)
        .to receive_message_chain(:visible, :pluck)
        .with(:id)
        .and_return([1])
      instance.where('project_id', '=', ['1'])
    end

    describe '#results' do
      it 'is the same as handwriting the query' do
        expected = base_scope
                   .where(["news.project_id IN (?)", ['1']])

        expect(instance.results.to_sql).to eql expected.to_sql
      end
    end

    describe '#valid?' do
      it 'is true' do
        expect(instance).to be_valid
      end

      it 'is invalid if the filter is invalid' do
        instance.where('project_id', '=', [''])
        expect(instance).to be_invalid
      end
    end
  end

  context 'with an order by id asc' do
    describe '#results' do
      it 'returns all visible news ordered by id asc' do
        expect(instance.order(id: :asc).results.to_sql)
          .to eql base_scope.except(:order).order(id: :asc).to_sql
      end
    end
  end
end
