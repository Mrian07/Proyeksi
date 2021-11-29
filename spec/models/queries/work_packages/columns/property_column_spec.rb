

require 'spec_helper'
require_relative 'shared_query_column_specs'

describe Queries::WorkPackages::Columns::PropertyColumn, type: :model do
  let(:instance) { described_class.new(:query_column) }

  it_behaves_like 'query column'

  describe 'instances' do
    context 'done_ratio disabled' do
      it 'the done ratio column does not exist' do
        allow(WorkPackage)
          .to receive(:done_ratio_disabled?)
          .and_return(true)

        expect(described_class.instances.map(&:name)).not_to include :done_ratio
      end
    end

    context 'done_ratio enabled' do
      it 'the done ratio column exists' do
        allow(WorkPackage)
          .to receive(:done_ratio_disabled?)
          .and_return(false)

        expect(described_class.instances.map(&:name)).to include :done_ratio
      end
    end
  end
end
