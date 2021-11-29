

require 'spec_helper'

describe Queries::Projects::ProjectQuery, type: :model do
  let(:instance) { described_class.new }
  let(:base_scope) { Project.all.order(id: :desc) }
  let(:current_user) { FactoryBot.build_stubbed(:admin) }

  before do
    login_as(current_user)
  end

  context 'without a filter' do
    context 'as an admin' do
      it 'is the same as getting all projects' do
        expect(instance.results.to_sql).to eql base_scope.to_sql
      end
    end

    context 'as a non admin' do
      let(:current_user) { FactoryBot.build_stubbed(:user) }

      it 'is the same as getting all visible projects' do
        expect(instance.results.to_sql).to eql base_scope.where(id: Project.visible).to_sql
      end
    end
  end

  context 'with a parent filter' do
    context 'with a "=" operator' do
      before do
        allow(Project)
          .to receive_message_chain(:visible, :pluck)
          .with(:id)
          .and_return([8])

        instance.where('parent_id', '=', ['8'])
      end

      it 'is the same as handwriting the query' do
        expected = base_scope
                     .where(["projects.parent_id IN (?)", ['8']])

        expect(instance.results.to_sql).to eql expected.to_sql
      end
    end
  end

  context 'with an ancestor filter' do
    context 'with a "=" operator' do
      before do
        instance.where('ancestor', '=', ['8'])
      end

      describe '#results' do
        it 'is the same as handwriting the query' do
          projects_table = Project.arel_table
          projects_ancestor_table = projects_table.alias(:ancestor_projects)

          condition = projects_table[:lft]
                        .gt(projects_ancestor_table[:lft])
                        .and(projects_table[:rgt].lt(projects_ancestor_table[:rgt]))
                        .and(projects_ancestor_table[:id].in(['8']))

          arel = projects_table
                   .join(projects_ancestor_table)
                   .on(condition)

          expected = base_scope.joins(arel.join_sources)

          expect(instance.results.to_sql).to eql expected.to_sql
        end
      end
    end

    context 'with a "!" operator' do
      before do
        instance.where('ancestor', '!', ['8'])
      end

      describe '#results' do
        it 'is the same as handwriting the query' do
          projects_table = Project.arel_table
          projects_ancestor_table = projects_table.alias(:ancestor_projects)

          condition = projects_table[:lft]
                      .gt(projects_ancestor_table[:lft])
                      .and(projects_table[:rgt].lt(projects_ancestor_table[:rgt]))

          arel = projects_table
                 .outer_join(projects_ancestor_table)
                 .on(condition)

          where_condition = projects_ancestor_table[:id]
                            .not_in(['8'])
                            .or(projects_ancestor_table[:id].eq(nil))

          expected = base_scope
                     .joins(arel.join_sources)
                     .where(where_condition)

          expect(instance.results.to_sql).to eql expected.to_sql
        end
      end
    end
  end

  context 'with an order by id asc' do
    describe '#results' do
      it 'returns all visible projects ordered by id asc' do
        expect(instance.order(id: :asc).results.to_sql)
          .to eql base_scope.except(:order).order(id: :asc).to_sql
      end
    end
  end
end
