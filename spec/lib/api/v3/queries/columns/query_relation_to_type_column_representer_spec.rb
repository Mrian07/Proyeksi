

require 'spec_helper'

describe ::API::V3::Queries::Columns::QueryRelationToTypeColumnRepresenter, clear_cache: true do
  include ::API::V3::Utilities::PathHelper

  let(:type) { FactoryBot.build_stubbed(:type) }
  let(:column) { Queries::WorkPackages::Columns::RelationToTypeColumn.new(type) }
  let(:representer) { described_class.new(column) }

  subject { representer.to_json }

  describe 'generation' do
    describe '_links' do
      it_behaves_like 'has a titled link' do
        let(:link) { 'self' }
        let(:href) { api_v3_paths.query_column "relationsToType#{type.id}" }
        let(:title) { "Relations to #{type.name}" }
      end

      it_behaves_like 'has a titled link' do
        let(:link) { 'type' }
        let(:href) { api_v3_paths.type type.id }
        let(:title) { type.name }
      end
    end

    it 'has _type QueryColumn::RelationToType' do
      is_expected
        .to be_json_eql('QueryColumn::RelationToType'.to_json)
        .at_path('_type')
    end

    it 'has id attribute' do
      is_expected
        .to be_json_eql("relationsToType#{type.id}".to_json)
        .at_path('id')
    end

    it 'has name attribute' do
      is_expected
        .to be_json_eql("Relations to #{type.name}".to_json)
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

    it 'busts the cache on changes to the type' do
      allow(type)
        .to receive(:cache_key)
        .and_return('a_different_one')

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
