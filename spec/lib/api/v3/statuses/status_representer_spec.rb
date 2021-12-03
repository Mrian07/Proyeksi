

require 'spec_helper'

describe ::API::V3::Statuses::StatusRepresenter do
  let(:status) { FactoryBot.build_stubbed(:status) }
  let(:representer) { described_class.new(status, current_user: double('current_user')) }

  context 'generation' do
    subject(:generated) { representer.to_json }

    it { is_expected.to include_json('Status'.to_json).at_path('_type') }

    describe 'status' do
      it { is_expected.to have_json_path('id') }
      it { is_expected.to have_json_path('name') }
      it { is_expected.to have_json_path('isClosed') }
      it { is_expected.to have_json_path('isDefault') }
      it { is_expected.to have_json_path('isReadonly') }
      it { is_expected.to have_json_path('position') }
      it { is_expected.to have_json_path('defaultDoneRatio') }

      describe 'values' do
        it { is_expected.to be_json_eql(status.id.to_json).at_path('id') }
        it { is_expected.to be_json_eql(status.name.to_json).at_path('name') }
        it { is_expected.to be_json_eql(status.is_closed.to_json).at_path('isClosed') }
        it { is_expected.to be_json_eql(status.is_default.to_json).at_path('isDefault') }
        it { is_expected.to be_json_eql(status.is_readonly.to_json).at_path('isReadonly') }
        it { is_expected.to be_json_eql(status.position.to_json).at_path('position') }
        it {
          is_expected.to be_json_eql(status.default_done_ratio.to_json).at_path('defaultDoneRatio')
        }
      end
    end

    describe '_links' do
      it { is_expected.to have_json_type(Object).at_path('_links') }

      describe 'self' do
        it_behaves_like 'has a titled link' do
          let(:link) { 'self' }
          let(:href) { "/api/v3/statuses/#{status.id}" }
          let(:title) { status.name }
        end
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
        let!(:former_cache_key) { representer.json_cache_key }

        it 'includes the name of the representer class' do
          expect(representer.json_cache_key)
            .to include('API', 'V3', 'Statuses', 'StatusRepresenter')
        end

        it 'changes when the locale changes' do
          I18n.with_locale(:fr) do
            expect(representer.json_cache_key)
              .not_to eql former_cache_key
          end
        end

        it 'changes when the status is updated' do
          status.updated_at = Time.now + 20.seconds

          expect(representer.json_cache_key)
            .not_to eql former_cache_key
        end
      end
    end
  end
end
