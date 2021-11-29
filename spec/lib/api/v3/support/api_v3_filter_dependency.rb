

shared_examples_for 'filter dependency' do
  it_behaves_like 'has basic schema properties' do
    let(:name) { 'Values' }
    let(:required) { true }
    let(:writable) { true }
    let(:has_default) { false }
    let(:location) { '_links' }
  end

  it_behaves_like 'does not link to allowed values'

  context 'when embedding' do
    let(:form_embedded) { true }

    it_behaves_like 'does not link to allowed values'
  end
end

shared_examples_for 'filter dependency with allowed link' do
  it_behaves_like 'has basic schema properties' do
    let(:name) { 'Values' }
    let(:required) { true }
    let(:writable) { true }
    let(:has_default) { false }
    let(:location) { '_links' }
  end

  it_behaves_like 'does not link to allowed values'

  context 'when embedding' do
    let(:form_embedded) { true }

    it_behaves_like 'links to allowed values via collection link'
  end
end

shared_examples_for 'filter dependency with allowed value link collection' do
  it_behaves_like 'has basic schema properties' do
    let(:name) { 'Values' }
    let(:required) { true }
    let(:writable) { true }
    let(:has_default) { false }
    let(:location) { '_links' }
  end

  it_behaves_like 'does not link to allowed values'

  context 'when embedding' do
    let(:form_embedded) { true }

    it_behaves_like 'links to allowed values directly'
  end
end

shared_examples_for 'filter dependency empty' do
  it 'is an empty object' do
    is_expected
      .to be_json_eql({}.to_json)
  end
end

shared_examples_for 'relation filter dependency' do
  include ::API::V3::Utilities::PathHelper

  let(:project) { FactoryBot.build_stubbed(:project) }
  let(:query) { FactoryBot.build_stubbed(:query, project: project) }
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
        context 'within project' do
          let(:path) { 'values' }
          let(:type) { '[]WorkPackage' }
          let(:href) { api_v3_paths.work_packages_by_project(project.id) }

          context "for operator 'Queries::Operators::Equals'" do
            let(:operator) { Queries::Operators::Equals }

            it_behaves_like 'filter dependency with allowed link'
          end

          context "for operator 'Queries::Operators::NotEquals'" do
            let(:operator) { Queries::Operators::NotEquals }

            it_behaves_like 'filter dependency with allowed link'
          end
        end

        context 'outside of a project' do
          let(:project) { nil }
          let(:path) { 'values' }
          let(:type) { '[]WorkPackage' }
          let(:href) { api_v3_paths.work_packages }

          context "for operator 'Queries::Operators::Equals'" do
            let(:operator) { Queries::Operators::Equals }

            it_behaves_like 'filter dependency with allowed link'
          end

          context "for operator 'Queries::Operators::NotEquals'" do
            let(:operator) { Queries::Operators::NotEquals }

            it_behaves_like 'filter dependency with allowed link'
          end
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

      it 'busts the cache on a different project' do
        query.project = other_project

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
