

require 'spec_helper'

describe Queries::Members::Filters::PrincipalFilter, type: :model do
  let(:user) { FactoryBot.build_stubbed(:user) }
  let(:group) { FactoryBot.build_stubbed(:group) }
  let(:current_user) { FactoryBot.build_stubbed(:user) }

  before do
    login_as(current_user)
  end

  before do
    principal_scope = double('principal scope')

    allow(Principal)
      .to receive(:not_locked)
      .and_return(principal_scope)

    allow(principal_scope)
      .to receive(:in_visible_project_or_me)
      .and_return([user, group, current_user])
  end

  it_behaves_like 'basic query filter' do
    let(:class_key) { :principal_id }
    let(:type) { :list_optional }
    let(:name) { Member.human_attribute_name(:principal) }

    describe '#allowed_values' do
      it 'is a list of the possible values' do
        expected = [[user.name, user.id.to_s],
                    [group.name, group.id.to_s],
                    [current_user.name, current_user.id.to_s],
                    %w(me me)]

        expect(instance.allowed_values).to match_array(expected)
      end
    end
  end

  it_behaves_like 'list_optional query filter' do
    let(:attribute) { :user_id }
    let(:model) { Member }
    let(:valid_values) { [user.id.to_s, group.id.to_s, current_user.id.to_s] }
  end
end
