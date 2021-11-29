

require 'spec_helper'

describe ::API::V3::Utilities::PathHelper do
  let(:helper) { Class.new.tap { |c| c.extend(described_class) }.api_v3_paths }

  describe '#cost_entry' do
    subject { helper.cost_entry 42 }

    it { is_expected.to eql('/api/v3/cost_entries/42') }
  end

  describe '#cost_entries_by_work_package' do
    subject { helper.cost_entries_by_work_package 42 }

    it { is_expected.to eql('/api/v3/work_packages/42/cost_entries') }
  end

  describe '#summarized_work_package_costs_by_type' do
    subject { helper.summarized_work_package_costs_by_type 42 }

    it { is_expected.to eql('/api/v3/work_packages/42/summarized_costs_by_type') }
  end

  describe '#cost_type' do
    subject { helper.cost_type 42 }

    it { is_expected.to eql('/api/v3/cost_types/42') }
  end
end
