#-- encoding: UTF-8



require 'spec_helper'

describe Queries::Roles::Filters::UnitFilter, type: :model do
  it_behaves_like 'basic query filter' do
    let(:class_key) { :unit }
    let(:type) { :list }
    let(:model) { Role }
  end

  it_behaves_like 'list query filter', scope: false do
    let(:attribute) { :type }
    let(:model) { Role }
    let(:valid_values) { ['project'] }

    describe '#scope' do
      context 'for the system value' do
        let(:values) { ['system'] }

        context 'for "="' do
          let(:operator) { '=' }

          it 'is the same as handwriting the query' do
            expected = model
                       .where(["roles.type = ?", GlobalRole.name])

            expect(instance.scope.to_sql).to eql expected.to_sql
          end
        end

        context 'for "!"' do
          let(:operator) { '!' }

          it 'is the same as handwriting the query' do
            expected = model
                       .where(["roles.type != ?", GlobalRole.name])

            expect(instance.scope.to_sql).to eql expected.to_sql
          end
        end
      end

      context 'for the projet value' do
        let(:values) { ['project'] }

        context 'for "="' do
          let(:operator) { '=' }

          it 'is the same as handwriting the query' do
            expected = model
                       .where(["roles.type = ? AND roles.builtin = ?", Role.name, Role::NON_BUILTIN])

            expect(instance.scope.to_sql).to eql expected.to_sql
          end
        end

        context 'for "!"' do
          let(:operator) { '!' }

          it 'is the same as handwriting the query' do
            expected = model
                       .where(["roles.type != ?", Role.name])

            expect(instance.scope.to_sql).to eql expected.to_sql
          end
        end
      end
    end
  end
end
