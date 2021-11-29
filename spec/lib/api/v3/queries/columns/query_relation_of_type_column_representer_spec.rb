

require 'spec_helper'

describe ::API::V3::Queries::Columns::QueryRelationOfTypeColumnRepresenter, clear_cache: true do
  include ::API::V3::Utilities::PathHelper

  let(:type) { { name: :label_relates_to, sym_name: :label_relates_to, order: 1, sym: :relation1 } }
  let(:column) { Queries::WorkPackages::Columns::RelationOfTypeColumn.new(type) }
  let(:representer) { described_class.new(column) }

  subject { representer.to_json }

  describe 'generation' do
    describe '_links' do
      it_behaves_like 'has a titled link' do
        let(:link) { 'self' }
        let(:href) { api_v3_paths.query_column "relationsOfType#{type[:sym].to_s.camelcase}" }
        let(:title) { "#{I18n.t(type[:name])} relations" }
      end
    end

    it 'has _type QueryColumn::RelationOfType' do
      is_expected
        .to be_json_eql('QueryColumn::RelationOfType'.to_json)
        .at_path('_type')
    end

    it 'has id attribute' do
      is_expected
        .to be_json_eql("relationsOfType#{type[:sym].to_s.camelcase}".to_json)
        .at_path('id')
    end

    it 'has relationType attribute' do
      is_expected
        .to be_json_eql(type[:sym].to_json)
        .at_path('relationType')
    end

    it 'has name attribute' do
      is_expected
        .to be_json_eql("#{I18n.t(type[:name])} relations".to_json)
        .at_path('name')
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
