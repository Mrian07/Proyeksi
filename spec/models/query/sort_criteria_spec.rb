

require 'spec_helper'

describe ::Query::SortCriteria, type: :model do
  let(:query) do
    FactoryBot.build_stubbed :query,
                             show_hierarchies: false
  end

  let(:available_criteria) { query.sortable_key_by_column_name }

  let(:instance) { described_class.new query.sortable_columns }
  subject { instance.to_a }

  before do
    instance.criteria = sort_criteria
    instance.available_criteria = available_criteria
  end

  describe 'ordered handling' do
    context 'with an empty sort_criteria' do
      let(:sort_criteria) { [] }

      it 'returns the default order by id' do
        expect(subject)
          .to eq [['work_packages.id DESC']]
      end
    end

    context 'with a sort_criteria for id' do
      let(:sort_criteria) { [['id']] }

      it 'returns the default order by id only once' do
        expect(subject)
          .to eq [['work_packages.id']]
      end
    end

    context 'with a sort_criteria for id ASC' do
      let(:sort_criteria) { [%w[id asc]] }

      it 'returns the custom order by id asc' do
        expect(subject)
          .to eq [['work_packages.id']]
      end
    end

    context 'with sort_criteria with order handling and no order statement' do
      let(:sort_criteria) { [['start_date']] }

      it 'adds the order handling (and the default order by id)' do
        expect(subject)
          .to eq [['work_packages.start_date NULLS LAST'], ['work_packages.id DESC']]
      end
    end

    context 'with sort_criteria with order handling and ASC order statement' do
      let(:sort_criteria) { [%w[start_date asc]] }

      it 'adds the order handling (and the default order by id)' do
        expect(subject)
          .to eq [['work_packages.start_date NULLS LAST'], ['work_packages.id DESC']]
      end
    end

    context 'with sort_criteria with order handling and DESC order statement' do
      let(:sort_criteria) { [%w[start_date desc]] }

      it 'adds the order handling (and the default order by id)' do
        expect(subject)
          .to eq [['work_packages.start_date DESC NULLS LAST'], ['work_packages.id DESC']]
      end
    end

    context 'with multiple sort_criteria with order handling and misc order statement' do
      let(:sort_criteria) { [%w[version desc], %w[start_date asc]] }

      it 'adds the order handling (and the default order by id)' do
        sort_sql = <<~SQL
          array_remove(regexp_split_to_array(regexp_replace(substring(versions.name from '^[^a-zA-Z]+'), '\\D+', ' ', 'g'), ' '), '')::int[]
        SQL

        expect(subject)
          .to eq [["#{sort_sql} DESC NULLS LAST", 'name DESC NULLS LAST'],
                  ['work_packages.start_date NULLS LAST'],
                  ['work_packages.id DESC']]
      end
    end
  end
end
