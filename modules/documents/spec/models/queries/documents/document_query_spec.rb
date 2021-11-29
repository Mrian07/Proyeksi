

require 'spec_helper'

describe Queries::Documents::DocumentQuery, type: :model do
  let(:user) { FactoryBot.build_stubbed(:user) }
  let(:base_scope) { Document.visible(user).order(id: :desc) }
  let(:instance) { described_class.new }

  before do
    login_as(user)
  end

  context 'without a filter' do
    describe '#results' do
      it 'is the same as getting all the visible documents' do
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
                     .where(["documents.project_id IN (?)", ['1']])

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
end
