

require 'spec_helper'

describe ::API::V3::Utilities::PathHelper do
  let(:helper) { Class.new.tap { |c| c.extend(described_class) }.api_v3_paths }

  describe '#budget' do
    subject { helper.budget 42 }

    it { is_expected.to eql('/api/v3/budgets/42') }
  end

  describe '#budget' do
    subject { helper.budget 42 }

    it { is_expected.to eql('/api/v3/budgets/42') }
  end

  describe '#budgets_by_project' do
    subject { helper.budgets_by_project 42 }

    it { is_expected.to eql('/api/v3/projects/42/budgets') }
  end

  describe '#attachments_by_budget' do
    subject { helper.attachments_by_budget 42 }

    it { is_expected.to eql('/api/v3/budgets/42/attachments') }
  end
end
