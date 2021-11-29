#-- encoding: UTF-8

require 'rspec'

require 'spec_helper'
require Rails.root + 'spec/lib/api/v3/work_packages/eager_loading/eager_loading_mock_wrapper'

describe ::API::V3::WorkPackages::EagerLoading::Checksum do
  let!(:bcf_issue) do
    FactoryBot.create(:bcf_issue,
                      work_package: work_package)
  end
  let!(:work_package) do
    FactoryBot.create(:work_package)
  end

  describe '.apply' do
    let!(:orig_checksum) do
      EagerLoadingMockWrapper
        .wrap(described_class, [work_package])
        .first
        .cache_checksum
    end

    let(:new_checksum) do
      EagerLoadingMockWrapper
        .wrap(described_class, [work_package])
        .first
        .cache_checksum
    end

    it 'produces a different checksum on changes to the bcf issue id' do
      bcf_issue.delete
      FactoryBot.create(:bcf_issue,
                        work_package: work_package)

      expect(new_checksum)
        .not_to eql orig_checksum
    end

    it 'produces a different checksum on changes to the bcf issue' do
      bcf_issue.update_column(:updated_at, Time.now + 10.seconds)

      expect(new_checksum)
        .not_to eql orig_checksum
    end
  end
end
