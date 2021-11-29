

require 'spec_helper'

describe ::API::V3::Queries::Schemas::CustomOptionFilterDependencyRepresenter, clear_cache: true do
  include ::API::V3::Utilities::PathHelper

  let(:project) { FactoryBot.build_stubbed(:project) }
  let(:query) { FactoryBot.build_stubbed(:query, project: project) }
  let(:custom_field) do
    cf = FactoryBot.build_stubbed(:list_wp_custom_field)

    allow(cf)
      .to receive(:custom_options)
      .and_return([FactoryBot.build_stubbed(:custom_option),
                   FactoryBot.build_stubbed(:custom_option)])
    cf
  end
  let(:filter) do
    Queries::WorkPackages::Filter::CustomFieldFilter.from_custom_field! custom_field: custom_field,
                                                                        context: query
  end
  let(:form_embedded) { false }

  let(:instance) do
    described_class.new(filter,
                        operator,
                        form_embedded: form_embedded)
  end

  subject(:generated) { instance.to_json }

  context 'generation' do
    context 'properties' do
      describe 'values' do
        let(:path) { 'values' }
        let(:type) { '[]CustomOption' }
        let(:hrefs) do
          custom_field.custom_options.map do |value|
            api_v3_paths.custom_option(value.id)
          end
        end

        context "for operator 'Queries::Operators::Equals'" do
          let(:operator) { Queries::Operators::Equals }

          it_behaves_like 'filter dependency with allowed value link collection'
        end

        context "for operator 'Queries::Operators::NotEquals'" do
          let(:operator) { Queries::Operators::NotEquals }

          it_behaves_like 'filter dependency with allowed value link collection'
        end

        context "for operator 'Queries::Operators::All'" do
          let(:operator) { Queries::Operators::All }

          it_behaves_like 'filter dependency empty'
        end

        context "for operator 'Queries::Operators::None'" do
          let(:operator) { Queries::Operators::None }

          it_behaves_like 'filter dependency empty'
        end
      end
    end

    describe 'caching' do
      let(:operator) { Queries::Operators::Equals }

      before do
        # fill the cache
        instance.extend(API::V3::Queries::Schemas::CustomFieldJsonCacheKeyMixin)
        instance.to_json
      end

      it 'is cached' do
        expect(instance)
          .not_to receive(:to_hash)

        instance.to_json
      end

      it 'busts the cache on a different operator' do
        instance.send(:operator=, Queries::Operators::NotEquals)

        expect(instance)
          .to receive(:to_hash)

        instance.to_json
      end

      it 'busts the cache on a different cache_key' do
        allow(custom_field)
          .to receive(:cache_key)
          .and_return('something else')

        expect(instance)
          .to receive(:to_hash)

        instance.to_json
      end

      it 'busts the cache on changes to the locale' do
        expect(instance)
          .to receive(:to_hash)

        I18n.with_locale(:de) do
          instance.to_json
        end
      end

      it 'busts the cache on different form_embedded' do
        embedded_instance = described_class.new(filter,
                                                operator,
                                                form_embedded: !form_embedded)
        expect(embedded_instance)
          .to receive(:to_hash)

        embedded_instance.to_json
      end
    end
  end
end
