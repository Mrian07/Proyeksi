

require 'spec_helper'

describe ::API::V3::Queries::Schemas::DateTimeFilterDependencyRepresenter, clear_cache: true do
  include ::API::V3::Utilities::PathHelper

  let(:project) { FactoryBot.build_stubbed(:project) }
  let(:query) { FactoryBot.build_stubbed(:query, project: project) }
  let(:filter) { Queries::WorkPackages::Filter::CreatedAtFilter.create!(context: query) }
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
        let(:type) { '[1]Integer' }

        context "for operator 'Queries::Operators::LessThanAgo" do
          let(:operator) { Queries::Operators::LessThanAgo }

          it_behaves_like 'filter dependency'
        end

        context "for operator 'Queries::Operators::MoreThanAgo'" do
          let(:operator) { Queries::Operators::MoreThanAgo }

          it_behaves_like 'filter dependency'
        end

        context "for operator 'Queries::Operators::Ago'" do
          let(:operator) { Queries::Operators::Ago }

          it_behaves_like 'filter dependency'
        end

        context "for operator 'Queries::Operators::Today'" do
          let(:operator) { Queries::Operators::Today }

          it_behaves_like 'filter dependency empty'
        end

        context "for operator 'Queries::Operators::ThisWeek'" do
          let(:operator) { Queries::Operators::ThisWeek }

          it_behaves_like 'filter dependency empty'
        end

        context "for operator 'Queries::Operators::OnDate'" do
          let(:operator) { Queries::Operators::OnDateTime }

          let(:type) { '[1]DateTime' }

          it_behaves_like 'filter dependency'
        end

        context "for operator 'Queries::Operators::BetweenDate'" do
          let(:operator) { Queries::Operators::BetweenDateTime }
          let(:type) { '[2]DateTime' }

          it_behaves_like 'filter dependency'
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
