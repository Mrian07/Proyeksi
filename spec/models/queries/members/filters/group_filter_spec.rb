#-- encoding: UTF-8



require 'spec_helper'

describe Queries::Members::Filters::GroupFilter, type: :model do
  let(:group1) { FactoryBot.build_stubbed(:group) }
  let(:group2) { FactoryBot.build_stubbed(:group) }

  before do
    allow(Group)
      .to receive(:pluck)
      .with(:id)
      .and_return([group1.id, group2.id])
  end

  it_behaves_like 'basic query filter' do
    let(:class_key) { :group }
    let(:type) { :list_optional }
    let(:name) { I18n.t('query_fields.member_of_group') }

    describe '#allowed_values' do
      it 'is a list of the possible values' do
        expected = [[group1.id, group1.id.to_s], [group2.id, group2.id.to_s]]

        expect(instance.allowed_values).to match_array(expected)
      end
    end
  end

  it_behaves_like 'list_optional group query filter' do
    let(:model) { Member.joins(:principal).merge(User.joins(:groups)) }
    let(:valid_values) { [group1.id.to_s] }
  end
end
