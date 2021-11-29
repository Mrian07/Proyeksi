

require 'spec_helper'

describe ::API::V3::Queries::QueryRepresenter do
  include ::API::V3::Utilities::PathHelper

  let(:query) { FactoryBot.build_stubbed(:query, project: project) }
  let(:project) { FactoryBot.build_stubbed(:project) }
  let(:user) { double('current_user') }
  let(:representer) do
    described_class.new(query, current_user: user, embed_links: true)
  end

  let(:permissions) { [] }

  let(:policy) do
    policy_stub = double('policy stub')

    allow(QueryPolicy)
      .to receive(:new)
      .with(user)
      .and_return(policy_stub)

    allow(policy_stub)
      .to receive(:allowed?)
      .and_return(false)

    permissions.each do |permission|
      allow(policy_stub)
        .to receive(:allowed?)
        .with(query, permission)
        .and_return(true)
    end
  end

  before do
    policy
  end

  subject { representer.from_hash request_body }

  describe 'parsing empty group_by (Regression #25606)' do
    before do
      query.group_by = 'project'
    end

    let(:request_body) do
      {
        '_links' => {
          'groupBy' => { 'href' => nil }
        }
      }
    end

    it 'should unset group_by' do
      expect(query).to be_grouped
      expect(query.group_by).to eq('project')

      expect(subject).not_to be_grouped
    end
  end

  describe 'parsing highlighted_attributes', with_ee: [:conditional_highlighting] do
    let(:request_body) do
      {
        '_links' => {
          'highlightedAttributes' => [{ 'href' => "/api/v3/queries/columns/type" }]
        }
      }
    end

    it 'should set highlighted_attributes' do
      expect(subject.highlighted_attributes).to eq(%i{type})
    end
  end

  describe 'parsing ordered work packages' do
    let(:request_body) do
      {
        'orderedWorkPackages' => {
          50 => 0,
          38 => 1234,
          102 => 81234123
        }
      }
    end

    before do
      allow(query).to receive(:new_record?).and_return(new_record)
    end

    context 'assuming query is new' do
      let(:new_record) { true }
      it 'should set ordered_work_packages' do
        order = subject.ordered_work_packages.map { |el| [el.work_package_id, el.position] }
        expect(order).to match_array [[50, 0], [38, 1234], [102, 81234123]]
      end
    end

    context 'assuming query is not new' do
      let(:new_record) { false }

      it 'should set ordered_work_packages' do
        expect(query)
          .not_to receive(:ordered_work_packages)

        subject
      end
    end
  end
end
