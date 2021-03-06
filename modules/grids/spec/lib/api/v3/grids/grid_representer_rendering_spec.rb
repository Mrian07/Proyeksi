

require 'spec_helper'

describe ::API::V3::Grids::GridRepresenter, 'rendering' do
  include ProyeksiApp::StaticRouting::UrlHelpers
  include API::V3::Utilities::PathHelper

  let(:grid) do
    FactoryBot.build_stubbed(
      :grid,
      row_count: 4,
      column_count: 5,
      widgets: [
        FactoryBot.build_stubbed(
          :grid_widget,
          identifier: 'work_packages_assigned',
          start_row: 4,
          end_row: 5,
          start_column: 1,
          end_column: 2
        ),
        FactoryBot.build_stubbed(
          :grid_widget,
          identifier: 'work_packages_created',
          start_row: 1,
          end_row: 2,
          start_column: 1,
          end_column: 2
        ),
        FactoryBot.build_stubbed(
          :grid_widget,
          identifier: 'work_packages_watched',
          start_row: 2,
          end_row: 4,
          start_column: 4,
          end_column: 5
        )
      ]
    )
  end

  let(:embed_links) { true }
  let(:current_user) { FactoryBot.build_stubbed(:user) }
  let(:representer) { described_class.new(grid, current_user: current_user, embed_links: embed_links) }

  let(:writable) { true }
  let(:scope_path) { 'bogus_scope' }
  let(:attachment_addable) { true }

  before do
    ProyeksiApp::Cache.clear

    allow(::Grids::Configuration)
      .to receive(:writable?)
      .with(grid, current_user)
      .and_return(writable)

    allow(::Grids::Configuration)
      .to receive(:to_scope)
      .with(Grids::Grid, [])
      .and_return(scope_path)

    allow(grid)
      .to receive(:attachments_addable?)
      .with(current_user)
      .and_return(attachment_addable)
  end

  context 'generation' do
    subject(:generated) { representer.to_json }

    context 'properties' do
      it 'denotes its type' do
        is_expected
          .to be_json_eql('Grid'.to_json)
          .at_path('_type')
      end

      it 'has an id' do
        is_expected
          .to be_json_eql(grid.id)
          .at_path('id')
      end

      it 'has a rowCount' do
        is_expected
          .to be_json_eql(4)
          .at_path('rowCount')
      end

      it 'has a columnCount' do
        is_expected
          .to be_json_eql(5)
          .at_path('columnCount')
      end

      describe 'createdAt' do
        it_behaves_like 'has UTC ISO 8601 date and time' do
          let(:date) { grid.created_at }
          let(:json_path) { 'createdAt' }
        end
      end

      describe 'updatedAt' do
        it_behaves_like 'has UTC ISO 8601 date and time' do
          let(:date) { grid.updated_at }
          let(:json_path) { 'updatedAt' }
        end
      end

      it 'has a list of widgets' do
        widgets = [
          {
            "_type": "GridWidget",
            "id": grid.widgets[0].id,
            "identifier": 'work_packages_assigned',
            "options": {},
            "startRow": 4,
            "endRow": 5,
            "startColumn": 1,
            "endColumn": 2
          },
          {
            "_type": "GridWidget",
            "id": grid.widgets[1].id,
            "identifier": 'work_packages_created',
            "options": {},
            "startRow": 1,
            "endRow": 2,
            "startColumn": 1,
            "endColumn": 2
          },
          {
            "_type": "GridWidget",
            "id": grid.widgets[2].id,
            "identifier": 'work_packages_watched',
            "options": {},
            "startRow": 2,
            "endRow": 4,
            "startColumn": 4,
            "endColumn": 5
          }
        ]

        is_expected
          .to be_json_eql(widgets.to_json)
          .at_path('widgets')
      end
    end

    context '_links' do
      context 'self link' do
        it_behaves_like 'has an untitled link' do
          let(:link) { 'self' }
          let(:href) { "/api/v3/grids/#{grid.id}" }
        end
      end

      context 'update link' do
        it_behaves_like 'has an untitled link' do
          let(:link) { 'update' }
          let(:href) { "/api/v3/grids/#{grid.id}/form" }
          let(:method) { :post }
        end
      end

      context 'updateImmediately link' do
        it_behaves_like 'has an untitled link' do
          let(:link) { 'updateImmediately' }
          let(:href) { "/api/v3/grids/#{grid.id}" }
          let(:method) { :patch }
        end
      end

      context 'scope link' do
        it_behaves_like 'has an untitled link' do
          let(:link) { 'scope' }
          let(:href) { scope_path }
          let(:type) { "text/html" }

          it 'has a content type of html' do
            is_expected
              .to be_json_eql(type.to_json)
              .at_path("_links/#{link}/type")
          end
        end
      end

      it_behaves_like 'has an untitled link' do
        let(:link) { 'attachments' }
        let(:href) { api_v3_paths.attachments_by_grid(grid.id) }
      end

      context 'addAttachments link' do
        it_behaves_like 'has an untitled link' do
          let(:link) { 'addAttachment' }
          let(:href) { api_v3_paths.attachments_by_grid(grid.id) }
        end

        context 'user is not allowed to edit work packages' do
          let(:attachment_addable) { false }

          it_behaves_like 'has no link' do
            let(:link) { 'addAttachment' }
          end
        end
      end
    end

    context 'embedded' do
      it 'embeds the attachments as collection' do
        is_expected
          .to be_json_eql('Collection'.to_json)
          .at_path('_embedded/attachments/_type')
      end
    end
  end
end
