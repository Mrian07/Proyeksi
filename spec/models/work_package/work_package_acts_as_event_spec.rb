

require 'spec_helper'

describe WorkPackage, type: :model do
  describe 'acts_as_event' do
    let(:stub_work_package) { FactoryBot.build_stubbed(:work_package) }

    describe '#event_url' do
      let(:expected_url) { { controller: :work_packages, action: :show, id: stub_work_package.id } }

      it { expect(stub_work_package.event_url).to eq(expected_url) }
    end
  end
end
