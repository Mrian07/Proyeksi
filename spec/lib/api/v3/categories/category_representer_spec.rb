

require 'spec_helper'

describe ::API::V3::Categories::CategoryRepresenter do
  let(:category) { FactoryBot.build_stubbed(:category) }
  let(:user) { FactoryBot.build(:user) }
  let(:representer) { described_class.new(category, current_user: double('current_user')) }

  context 'generation' do
    subject(:generated) { representer.to_json }

    shared_examples_for 'category has core values' do
      it { is_expected.to include_json('Category'.to_json).at_path('_type') }

      it { is_expected.to have_json_type(Object).at_path('_links') }
      it 'should link to self' do
        expect(subject).to have_json_path('_links/self/href')
      end
      it 'should display its name as title in self' do
        expect(subject).to have_json_path('_links/self/title')
      end
      it 'should link to its project' do
        expect(subject).to have_json_path('_links/project/href')
      end
      it 'should display its project title' do
        expect(subject).to have_json_path('_links/project/title')
      end

      it { is_expected.to have_json_path('id') }
      it { is_expected.to have_json_path('name') }
    end

    context 'default assignee not set' do
      it_behaves_like 'category has core values'

      it 'should not link to an assignee' do
        expect(subject).not_to have_json_path('_links/defaultAssignee')
      end
    end

    context 'default assignee set' do
      let(:category) do
        FactoryBot.build_stubbed(:category, assigned_to: user)
      end
      it_behaves_like 'category has core values'

      it 'should link to its default assignee' do
        expect(subject).to have_json_path('_links/defaultAssignee/href')
      end
      it 'should display the name of its default assignee' do
        expect(subject).to have_json_path('_links/defaultAssignee/title')
      end
    end

    describe 'caching' do
      it 'is based on the representer\'s cache_key' do
        expect(ProyeksiApp::Cache)
          .to receive(:fetch)
          .with(representer.json_cache_key)
          .and_call_original

        representer.to_json
      end

      describe '#json_cache_key' do
        let(:assigned_to) { FactoryBot.build_stubbed(:user) }

        before do
          category.assigned_to = assigned_to
        end
        let!(:former_cache_key) { representer.json_cache_key }

        it 'includes the name of the representer class' do
          expect(representer.json_cache_key)
            .to include('API', 'V3', 'Categories', 'CategoryRepresenter')
        end

        it 'changes when the locale changes' do
          I18n.with_locale(:fr) do
            expect(representer.json_cache_key)
              .not_to eql former_cache_key
          end
        end

        it 'changes when the category is updated' do
          category.updated_at = Time.now + 20.seconds

          expect(representer.json_cache_key)
            .not_to eql former_cache_key
        end

        it 'changes when the category\'s project is updated' do
          category.project.updated_at = Time.now + 20.seconds

          expect(representer.json_cache_key)
            .not_to eql former_cache_key
        end

        it 'changes when the category\'s assigned_to is updated' do
          category.assigned_to.updated_at = Time.now + 20.seconds

          expect(representer.json_cache_key)
            .not_to eql former_cache_key
        end
      end
    end
  end
end
