

require 'spec_helper'

describe Queries::TimeEntries::TimeEntryQuery, type: :model do
  let(:user) { FactoryBot.build_stubbed(:user) }
  let(:base_scope) { TimeEntry.visible(user).order(id: :desc) }
  let(:instance) { described_class.new }

  before do
    login_as(user)
  end

  context 'without a filter' do
    describe '#results' do
      it 'is the same as getting all the time entries' do
        expect(instance.results.to_sql).to eql base_scope.to_sql
      end
    end
  end

  context 'with a user filter' do
    let(:values) { ['1'] }
    before do
      allow(Principal)
        .to receive_message_chain(:in_visible_project, :pluck)
        .with(:id)
        .and_return([1])
    end

    subject do
      instance.where('user_id', '=', values)
      instance
    end

    describe '#results' do
      it 'is the same as handwriting the query' do
        expected = base_scope
                   .where(["time_entries.user_id IN (?)", values])

        expect(subject.results.to_sql).to eql expected.to_sql
      end

      context 'with a me value' do
        let(:values) { ['me'] }

        it 'replaces the value to produce the query' do
          expected = base_scope
                     .where(["time_entries.user_id IN (?)", [user.id.to_s]])

          expect(subject.results.to_sql).to eql expected.to_sql
        end
      end
    end

    describe '#valid?' do
      it 'is true' do
        expect(subject).to be_valid
      end

      context 'with a me value and being logged in' do
        let(:values) { ['me'] }

        it 'is valid' do
          expect(subject).to be_valid
        end
      end

      context 'with not existing values' do
        let(:values) { [''] }

        it 'is invalid' do
          expect(subject).to be_invalid
        end
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
                   .where(["time_entries.project_id IN (?)", ['1']])

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

  context 'with a work_package filter' do
    before do
      allow(WorkPackage)
        .to receive_message_chain(:visible, :pluck)
        .with(:id)
        .and_return([1])
      instance.where('work_package_id', '=', ['1'])
    end

    describe '#results' do
      it 'is the same as handwriting the query' do
        expected = base_scope
                   .where(["time_entries.work_package_id IN (?)", ['1']])

        expect(instance.results.to_sql).to eql expected.to_sql
      end
    end

    describe '#valid?' do
      it 'is true' do
        expect(instance).to be_valid
      end

      it 'is invalid if the filter is invalid' do
        instance.where('work_package_id', '=', [''])
        expect(instance).to be_invalid
      end
    end
  end

  context 'with an order by id asc' do
    describe '#results' do
      it 'returns all visible time entries ordered by id asc' do
        expect(instance.order(id: :asc).results.to_sql)
          .to eql base_scope.except(:order).order(id: :asc).to_sql
      end
    end
  end
end
