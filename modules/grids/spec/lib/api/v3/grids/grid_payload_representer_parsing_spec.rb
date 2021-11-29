

require 'spec_helper'

describe ::API::V3::Grids::GridPayloadRepresenter, 'parsing' do
  include ::API::V3::Utilities::PathHelper

  let(:object) do
    OpenStruct.new
  end
  let(:user) { FactoryBot.build_stubbed(:user) }
  let(:representer) do
    described_class.create(object, current_user: user, embed_links: true)
  end

  let(:hash) do
    {
      "rowCount" => 10,
      "columnCount" => 20,
      "widgets" => [
        {
          "_type": "Widget",
          "identifier": 'work_packages_assigned',
          "startRow": 4,
          "endRow": 5,
          "startColumn": 1,
          "endColumn": 2
        },
        {
          "_type": "Widget",
          "identifier": 'work_packages_created',
          "startRow": 1,
          "endRow": 2,
          "startColumn": 1,
          "endColumn": 2
        },
        {
          "_type": "Widget",
          "identifier": 'work_packages_watched',
          "startRow": 2,
          "endRow": 4,
          "startColumn": 4,
          "endColumn": 5
        }
      ],
      "_links" => {
        "scope" => {
          "href" => 'some_path'
        }
      }
    }
  end

  describe '_links' do
    context 'scope' do
      it 'updates page' do
        grid = representer.from_hash(hash)
        expect(grid.scope)
          .to eql('some_path')
      end
    end
  end

  describe 'properties' do
    context 'rowCount' do
      it 'updates row_count' do
        grid = representer.from_hash(hash)
        expect(grid.row_count)
          .to eql(10)
      end
    end

    context 'columnCount' do
      it 'updates column_count' do
        grid = representer.from_hash(hash)
        expect(grid.column_count)
          .to eql(20)
      end
    end

    context 'widgets' do
      it 'updates widgets' do
        grid = representer.from_hash(hash)

        expect(grid.widgets[0].identifier)
          .to eql('work_packages_assigned')
        expect(grid.widgets[0].start_row)
          .to eql(4)
        expect(grid.widgets[0].end_row)
          .to eql(5)
        expect(grid.widgets[0].start_column)
          .to eql(1)
        expect(grid.widgets[0].end_column)
          .to eql(2)

        expect(grid.widgets[1].identifier)
          .to eql('work_packages_created')
        expect(grid.widgets[1].start_row)
          .to eql(1)
        expect(grid.widgets[1].end_row)
          .to eql(2)
        expect(grid.widgets[1].start_column)
          .to eql(1)
        expect(grid.widgets[1].end_column)
          .to eql(2)

        expect(grid.widgets[2].identifier)
          .to eql('work_packages_watched')
        expect(grid.widgets[2].start_row)
          .to eql(2)
        expect(grid.widgets[2].end_row)
          .to eql(4)
        expect(grid.widgets[2].start_column)
          .to eql(4)
        expect(grid.widgets[2].end_column)
          .to eql(5)
      end
    end
  end
end
