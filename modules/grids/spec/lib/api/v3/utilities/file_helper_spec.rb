

require 'spec_helper'

describe ::API::V3::Utilities::PathHelper do
  let(:helper) { Class.new.tap { |c| c.extend(::API::V3::Utilities::PathHelper) }.api_v3_paths }

  context 'attachments paths' do
    describe '#attachments_by_grid' do
      subject { helper.attachments_by_grid 1 }

      it 'provides the path' do
        is_expected.to match('/grids/1/attachments')
      end
    end
  end
end
