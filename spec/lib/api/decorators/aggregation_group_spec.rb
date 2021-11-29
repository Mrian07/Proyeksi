

require 'spec_helper'

describe ::API::Decorators::AggregationGroup do
  let(:query) do
    query = FactoryBot.build_stubbed(:query)
    query.group_by = :assigned_to

    query
  end
  let(:group_key) { OpenStruct.new name: 'ABC' }
  let(:count) { 5 }
  let(:current_user) { FactoryBot.build_stubbed(:user) }

  subject { described_class.new(group_key, count, query: query, current_user: current_user).to_json }

  context 'with an empty array key' do
    let(:group_key) { [] }

    it 'has an empty value' do
      is_expected
        .to be_json_eql(nil.to_json)
        .at_path('value')
    end
  end
end
