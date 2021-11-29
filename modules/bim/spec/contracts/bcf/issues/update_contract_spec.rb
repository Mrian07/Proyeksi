

require 'spec_helper'
require_relative './shared_contract_examples'

describe Bim::Bcf::Issues::UpdateContract do
  it_behaves_like 'issues contract' do
    let(:issue) do
      FactoryBot.build_stubbed(:bcf_issue,
                               work_package: issue_work_package).tap do |i|
        # in order to actually have something changed
        i.index = issue_index
      end
    end
    let(:permissions) { [:manage_bcf] }

    subject(:contract) { described_class.new(issue, current_user) }

    context 'if work_package is altered' do
      before do
        issue.work_package = FactoryBot.build_stubbed(:stubbed_work_package)
      end

      it 'is invalid' do
        expect_valid(false, work_package_id: %i(error_readonly))
      end
    end
  end
end
