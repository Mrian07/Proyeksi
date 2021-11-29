

require 'spec_helper'

describe ::API::V3::Queries::Schemas::FloatFilterDependencyRepresenter, clear_cache: true do
  include ::API::V3::Utilities::PathHelper

  let(:project) { FactoryBot.build_stubbed(:project) }
  let(:query) { FactoryBot.build_stubbed(:query, project: project) }
  let(:custom_field) { FactoryBot.build_stubbed(:float_wp_custom_field) }
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
        let(:type) { '[1]Float' }

        context "for operator 'Queries::Operators::Equals'" do
          let(:operator) { Queries::Operators::Equals }

          it_behaves_like 'filter dependency'
        end

        context "for operator 'Queries::Operators::NotEquals'" do
          let(:operator) { Queries::Operators::NotEquals }

          it_behaves_like 'filter dependency'
        end

        context "for operator 'Queries::Operators::GreaterOrEqual'" do
          let(:operator) { Queries::Operators::GreaterOrEqual }

          it_behaves_like 'filter dependency'
        end

        context "for operator 'Queries::Operators::LessOrEqual'" do
          let(:operator) { Queries::Operators::LessOrEqual }

          it_behaves_like 'filter dependency'
        end

        context "for operator 'Queries::Operators::None'" do
          let(:operator) { Queries::Operators::None }

          it_behaves_like 'filter dependency empty'
        end

        context "for operator 'Queries::Operators::All'" do
          let(:operator) { Queries::Operators::All }

          it_behaves_like 'filter dependency empty'
        end
      end
    end

    describe 'caching' do
      let(:operator) { Queries::Operators::Equals }
      let(:other_project) { FactoryBot.build_stubbed(:project) }

      before do
        # fill the cache
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
