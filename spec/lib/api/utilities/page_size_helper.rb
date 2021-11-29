

require 'spec_helper'

describe ::API::Utilities::PageSizeHelper do
  let(:clazz) do
    Class.new do
      include ::API::Utilities::PageSizeHelper
    end
  end
  let(:subject) { clazz.new }

  describe '#maximum_page_size' do
    context 'when small values in per_page_options',
            with_settings: { per_page_options: '20,100' } do
      it 'uses the magical number 500' do
        expect(subject.maximum_page_size).to eq(500)
      end
    end

    context 'when larger values in per_page_options',
            with_settings: { per_page_options: '20,100,1000' } do
      it 'uses that value' do
        expect(subject.maximum_page_size).to eq(1000)
      end
    end
  end
end
