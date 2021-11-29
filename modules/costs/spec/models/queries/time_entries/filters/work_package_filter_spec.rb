#-- encoding: UTF-8



require 'spec_helper'

describe Queries::TimeEntries::Filters::WorkPackageFilter, type: :model do
  let(:work_package1) { FactoryBot.build_stubbed(:work_package) }
  let(:work_package2) { FactoryBot.build_stubbed(:work_package) }

  before do
    allow(WorkPackage)
      .to receive_message_chain(:visible, :pluck)
      .with(:id)
      .and_return([work_package1.id, work_package2.id])
  end

  it_behaves_like 'basic query filter' do
    let(:class_key) { :work_package_id }
    let(:type) { :list_optional }
    let(:name) { TimeEntry.human_attribute_name(:work_package) }

    describe '#allowed_values' do
      it 'is a list of the possible values' do
        expected = [[work_package1.id, work_package1.id.to_s], [work_package2.id, work_package2.id.to_s]]

        expect(instance.allowed_values).to match_array(expected)
      end
    end
  end

  it_behaves_like 'list_optional query filter' do
    let(:attribute) { :work_package_id }
    let(:model) { TimeEntry }
    let(:valid_values) { [work_package1.id.to_s] }
  end
end
