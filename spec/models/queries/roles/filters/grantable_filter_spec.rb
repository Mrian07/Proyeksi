#-- encoding: UTF-8



require 'spec_helper'

describe Queries::Roles::Filters::GrantableFilter, type: :model do
  it_behaves_like 'basic query filter' do
    let(:class_key) { :grantable }
    let(:type) { :list }
    let(:model) { Role }
  end

  it_behaves_like 'boolean query filter', scope: false do
    let(:model) { Role }
    let(:attribute) { :type }

    describe '#scope' do
      context 'for the true value' do
        let(:values) { [ProyeksiApp::Database::DB_VALUE_TRUE] }

        context 'for "="' do
          let(:operator) { '=' }

          it 'is the same as handwriting the query' do
            expected = expected_base_scope
                       .where(["#{expected_table_name}.builtin IN (?)", Role::NON_BUILTIN])

            expect(instance.scope.to_sql).to eql expected.to_sql
          end
        end

        context 'for "!"' do
          let(:operator) { '!' }

          it 'is the same as handwriting the query' do
            expected = expected_base_scope
                       .where(["#{expected_table_name}.builtin NOT IN (?)", Role::NON_BUILTIN])

            expect(instance.scope.to_sql).to eql expected.to_sql
          end
        end
      end

      context 'for the false value' do
        let(:values) { [ProyeksiApp::Database::DB_VALUE_FALSE] }

        context 'for "="' do
          let(:operator) { '=' }

          it 'is the same as handwriting the query' do
            expected = expected_base_scope
                       .where(["#{expected_table_name}.builtin IN (?)", [Role::BUILTIN_ANONYMOUS, Role::BUILTIN_NON_MEMBER]])

            expect(instance.scope.to_sql).to eql expected.to_sql
          end
        end

        context 'for "!"' do
          let(:operator) { '!' }

          it 'is the same as handwriting the query' do
            expected = expected_base_scope
                       .where(["#{expected_table_name}.builtin NOT IN (?)", [Role::BUILTIN_ANONYMOUS, Role::BUILTIN_NON_MEMBER]])

            expect(instance.scope.to_sql).to eql expected.to_sql
          end
        end
      end
    end
  end
end
