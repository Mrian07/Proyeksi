

require 'spec_helper'

describe ::API::V3::Queries::GroupBys::QueryGroupByRepresenter, clear_cache: true do
  include ::API::V3::Utilities::PathHelper

  let(:column) { Query.available_columns.detect { |column| column.name == :status } }
  let(:representer) { described_class.new(column) }

  subject { representer.to_json }

  describe 'generation' do
    describe '_links' do
      it_behaves_like 'has a titled link' do
        let(:link) { 'self' }
        let(:href) { api_v3_paths.query_group_by 'status' }
        let(:title) { 'Status' }
      end
    end

    it 'has _type QueryGroupBy' do
      is_expected
        .to be_json_eql('QueryGroupBy'.to_json)
        .at_path('_type')
    end

    it 'has id attribute' do
      is_expected
        .to be_json_eql('status'.to_json)
        .at_path('id')
    end

    it 'has name attribute' do
      is_expected
        .to be_json_eql('Status'.to_json)
        .at_path('name')
    end

    context 'for a translated column' do
      let(:column) { Query.available_columns.detect { |column| column.name == :assigned_to } }

      describe '_links' do
        it_behaves_like 'has a titled link' do
          let(:link) { 'self' }
          let(:href) { api_v3_paths.query_group_by 'assignee' }
          let(:title) { 'Assignee' }
        end
      end

      it 'has id attribute' do
        is_expected
          .to be_json_eql('assignee'.to_json)
          .at_path('id')
      end

      it 'has name attribute' do
        is_expected
          .to be_json_eql('Assignee'.to_json)
          .at_path('name')
      end
    end
  end

  describe 'caching' do
    before do
      # fill the cache
      representer.to_json
    end

    it 'is cached' do
      expect(representer)
        .not_to receive(:to_hash)

      representer.to_json
    end

    it 'busts the cache on changes to the caption (cf rename)' do
      allow(column)
        .to receive(:caption)
        .and_return('blubs')

      expect(representer)
        .to receive(:to_hash)

      representer.to_json
    end

    it 'busts the cache on changes to the name' do
      allow(column)
        .to receive(:name)
        .and_return('blubs')

      expect(representer)
        .to receive(:to_hash)

      representer.to_json
    end

    it 'busts the cache on changes to the locale' do
      expect(representer)
        .to receive(:to_hash)

      I18n.with_locale(:de) do
        representer.to_json
      end
    end
  end
end
