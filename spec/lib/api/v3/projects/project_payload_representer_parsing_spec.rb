

require 'spec_helper'

describe ::API::V3::Projects::ProjectPayloadRepresenter, 'parsing' do
  include ::API::V3::Utilities::PathHelper

  let(:object) do
    OpenStruct.new available_custom_fields: []
  end
  let(:user) { FactoryBot.build_stubbed(:user) }
  let(:representer) do
    described_class.create(object, current_user: user)
  end

  describe 'properties' do
    context 'status' do
      let(:hash) do
        {
          'statusExplanation' => { 'raw' => 'status code explanation' },
          '_links' => {
            'status' => {
              'href' => api_v3_paths.project_status('on_track')
            }
          }
        }
      end

      it 'updates code' do
        project = representer.from_hash(hash)
        expect(project.status[:code])
          .to eql('on_track')

        expect(project.status[:explanation])
          .to eql('status code explanation')
      end

      context 'with code not provided' do
        let(:hash) do
          {
            'statusExplanation' => { 'raw' => 'status code explanation' }
          }
        end

        it 'does not set code' do
          project = representer.from_hash(hash)
          expect(project.status[:code])
            .to be_nil
        end

        it 'updates explanation' do
          project = representer.from_hash(hash)
          expect(project.status[:explanation])
            .to eql('status code explanation')
        end
      end

      context 'with explanation not provided' do
        let(:hash) do
          {
            '_links' => {
              'status' => {
                'href' => api_v3_paths.project_status('off_track')
              }
            }
          }
        end

        it 'does set code' do
          project = representer.from_hash(hash)
          expect(project.status[:code])
            .to eql 'off_track'
        end

        it 'does not set explanation' do
          project = representer.from_hash(hash)
          expect(project.status[:explanation])
            .to be_nil
        end
      end

      context 'with null for a status' do
        let(:hash) do
          {
            '_links' => {
              'status' => {
                'href' => nil
              }
            }
          }
        end

        it 'does set status to nil' do
          project = representer.from_hash(hash).to_h

          expect(project)
            .to have_key(:status)

          status = project[:status]
          expect(status.to_h)
            .to have_key(:code)

          expect(status.to_h)
            .not_to have_key(:explanation)

          expect(status[:code])
            .to eq nil
        end
      end
    end
  end

  describe '_links' do
    context 'with a parent link' do
      context 'with the href being an url' do
        let(:hash) do
          {
            '_links' => {
              'parent' => {
                'href' => api_v3_paths.project(5)
              }
            }
          }
        end

        it 'sets the parent_id to the value' do
          project = representer.from_hash(hash).to_h

          expect(project[:parent_id])
            .to eq "5"
        end
      end

      context 'with the href being nil' do
        let(:hash) do
          {
            '_links' => {
              'parent' => {
                'href' => nil
              }
            }
          }
        end

        it 'sets the parent_id to nil' do
          project = representer.from_hash(hash).to_h

          expect(project)
            .to have_key(:parent_id)

          expect(project[:parent_id])
            .to eq nil
        end
      end

      context 'with the href being the hidden uri' do
        let(:hash) do
          {
            '_links' => {
              'parent' => {
                'href' => API::V3::URN_UNDISCLOSED
              }
            }
          }
        end

        it 'omits the parent information' do
          project = representer.from_hash(hash).to_h

          expect(project)
            .not_to have_key(:parent_id)
        end
      end
    end
  end
end
