

require 'spec_helper'

describe WorkPackage, 'status', type: :model do
  let(:status) { FactoryBot.create(:status) }
  let!(:work_package) do
    FactoryBot.create(:work_package,
                      status: status)
  end

  describe '#readonly' do
    let(:status) { FactoryBot.create(:status, is_readonly: true) }

    context 'with EE', with_ee: %i[readonly_work_packages] do
      it 'marks work package as read only' do
        expect(work_package).to be_readonly_status
      end
    end

    context 'without EE' do
      it 'is not marked as read only' do
        expect(work_package).not_to be_readonly_status
      end
    end
  end
end
