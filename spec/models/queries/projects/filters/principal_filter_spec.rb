#-- encoding: UTF-8



require 'spec_helper'

describe Queries::Projects::Filters::PrincipalFilter, type: :model do
  let(:group1) { FactoryBot.build_stubbed(:group) }
  let(:group2) { FactoryBot.build_stubbed(:group) }
  let(:user1) { FactoryBot.build_stubbed(:user) }
  let(:user2) { FactoryBot.build_stubbed(:user) }

  before do
    allow(Principal)
      .to receive(:pluck)
      .with(:id)
      .and_return([group1.id,
                   group2.id,
                   user1.id,
                   user2.id])
  end

  it_behaves_like 'basic query filter' do
    let(:class_key) { :principal }
    let(:type) { :list_optional }
    let(:name) { Principal.model_name.human }

    describe '#allowed_values' do
      it 'is a list of the possible values' do
        expected = [[group1.id, group1.id.to_s],
                    [group2.id, group2.id.to_s],
                    [user1.id, user1.id.to_s],
                    [user2.id, user2.id.to_s]]

        expect(instance.allowed_values).to match_array(expected)
      end
    end
  end
end
