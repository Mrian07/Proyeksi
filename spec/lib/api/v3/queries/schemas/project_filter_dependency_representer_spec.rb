

require 'spec_helper'

describe ::API::V3::Queries::Schemas::ProjectFilterDependencyRepresenter, clear_cache: true do
  include ::API::V3::Utilities::PathHelper

  let(:filter) { Queries::WorkPackages::Filter::ProjectFilter.create! }
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
        let(:type) { '[]Project' }
        let(:filters) { "?filters=%5B%7B%22active%22%3A%7B%22operator%22%3A%22%3D%22%2C%22values%22%3A%5B%22t%22%5D%7D%7D%5D" }
        let(:href) { api_v3_paths.projects + filters }

        context "for operator 'Queries::Operators::Equals'" do
          let(:operator) { Queries::Operators::Equals }

          it_behaves_like 'filter dependency with allowed link'
        end

        context "for operator 'Queries::Operators::NotEquals'" do
          let(:operator) { Queries::Operators::NotEquals }

          it_behaves_like 'filter dependency with allowed link'
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
