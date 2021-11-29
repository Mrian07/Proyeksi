

require 'spec_helper'
require_relative './shared_contract_examples'

describe Bim::Bcf::Issues::CreateContract do
  it_behaves_like 'issues contract' do
    let(:issue) do
      Bim::Bcf::Issue.new(uuid: issue_uuid,
                          work_package: issue_work_package,
                          index: issue_index)
    end
    let(:permissions) { [:manage_bcf] }

    subject(:contract) { described_class.new(issue, current_user) }
  end
end
