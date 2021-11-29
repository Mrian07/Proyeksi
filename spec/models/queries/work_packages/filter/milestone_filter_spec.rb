

require 'spec_helper'

describe Queries::WorkPackages::Filter::MilestoneFilter, type: :model do
  it_behaves_like 'basic query filter' do
    let(:type) { :list }
    let(:class_key) { :is_milestone }

    describe '#available?' do
      context 'within a project' do
        before do
          allow(project)
            .to receive_message_chain(:rolled_up_types, :exists?)
            .and_return true
        end

        it 'is true' do
          expect(instance).to be_available
        end

        it 'is false without a type' do
          allow(project)
            .to receive_message_chain(:rolled_up_types, :exists?)
            .and_return false

          expect(instance).to_not be_available
        end
      end

      context 'without a project' do
        let(:project) { nil }

        before do
          allow(Type)
            .to receive_message_chain(:order, :exists?)
            .and_return true
        end

        it 'is true' do
          expect(instance).to be_available
        end

        it 'is false without a type' do
          allow(Type)
            .to receive_message_chain(:order, :exists?)
            .and_return false

          expect(instance).to_not be_available
        end
      end
    end
  end

  it_behaves_like 'boolean query filter', scope: false do
    let(:model) { WorkPackage.unscoped }
    let(:attribute) { :id }

    describe '#scope' do
      context 'for the true value' do
        let(:values) { [OpenProject::Database::DB_VALUE_TRUE] }

        context 'for "="' do
          let(:operator) { '=' }

          it 'is the same as handwriting the query' do
            expected = 'type_id IN (SELECT "types"."id" FROM "types" WHERE "types"."is_milestone" = TRUE ORDER BY position ASC)'

            expect(instance.where).to eql expected
          end
        end

        context 'for "!"' do
          let(:operator) { '!' }

          it 'is the same as handwriting the query' do
            expected = 'type_id NOT IN (SELECT "types"."id" FROM "types" WHERE "types"."is_milestone" = TRUE ORDER BY position ASC)'

            expect(instance.where).to eql expected
          end
        end
      end

      context 'for the false value' do
        let(:values) { [OpenProject::Database::DB_VALUE_FALSE] }

        context 'for "="' do
          let(:operator) { '=' }

          it 'is the same as handwriting the query' do
            expected = 'type_id NOT IN (SELECT "types"."id" FROM "types" WHERE "types"."is_milestone" = TRUE ORDER BY position ASC)'

            expect(instance.where).to eql expected
          end
        end

        context 'for "!"' do
          let(:operator) { '!' }

          it 'is the same as handwriting the query' do
            expected = 'type_id IN (SELECT "types"."id" FROM "types" WHERE "types"."is_milestone" = TRUE ORDER BY position ASC)'

            expect(instance.where).to eql expected
          end
        end
      end
    end
  end
end
