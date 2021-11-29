

require 'spec_helper'

describe UpdateQueryFromParamsService,
         type: :model do
  let(:user) { FactoryBot.build_stubbed(:user) }
  let(:query) { FactoryBot.build_stubbed(:query) }

  let(:instance) { described_class.new(query, user) }

  let(:params) { {} }

  describe '#call' do
    subject { instance.call(params) }

    context 'group_by' do
      context 'for an existing value' do
        let(:params) { { group_by: 'status' } }

        it 'sets the value' do
          subject

          expect(query.group_by).to eql('status')
        end

        context 'when hierarchy was set previously' do
          it 'disables the mode when not given' do
            subject

            expect(query.group_by).to eql('status')
            expect(query.show_hierarchies).to eql(false)
            expect(subject).to be_success
          end
        end
      end

      context 'when passed along with hierarchy mode' do
        let(:params) { { group_by: 'status', show_hierarchies: true } }

        it 'sets both values' do
          subject

          expect(query.group_by).to eql('status')
          expect(query.show_hierarchies).to eql(true)
          expect(subject).not_to be_success
        end
      end
    end

    context 'filters' do
      let(:params) do
        { filters: [{ field: 'status_id', operator: '=', values: ['1', '2'] }] }
      end

      context 'for a valid filter' do
        it 'sets the filter' do
          subject

          expect(query.filters.length)
            .to eql(1)
          expect(query.filters[0].name)
            .to eql(:status_id)
          expect(query.filters[0].operator)
            .to eql('=')
          expect(query.filters[0].values)
            .to eql(['1', '2'])
        end
      end
    end

    context 'sort_by' do
      let(:params) do
        { sort_by: [['status_id', 'desc']] }
      end

      it 'sets the order' do
        subject

        expect(query.sort_criteria)
          .to eql([['status_id', 'desc']])
      end
    end

    context 'columns' do
      let(:params) do
        { columns: ['assigned_to', 'author', 'category', 'subject'] }
      end

      it 'sets the columns' do
        subject

        expect(query.column_names)
          .to match_array(params[:columns].map(&:to_sym))
      end
    end
  end
end
