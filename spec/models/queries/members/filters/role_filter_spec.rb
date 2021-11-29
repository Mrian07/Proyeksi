#-- encoding: UTF-8



require 'spec_helper'

describe Queries::Members::Filters::RoleFilter, type: :model do
  let(:role1) { FactoryBot.build_stubbed(:role) }
  let(:role2) { FactoryBot.build_stubbed(:role) }

  before do
    allow(Role)
      .to receive(:pluck)
      .with(:name, :id)
      .and_return([[role1.name, role1.id], [role2.name, role2.id]])
  end

  it_behaves_like 'basic query filter' do
    let(:class_key) { :role_id }
    let(:type) { :list_optional }
    let(:name) { Member.human_attribute_name(:role) }

    describe '#allowed_values' do
      it 'is a list of the possible values' do
        expected = [[role1.name, role1.id], [role2.name, role2.id]]

        expect(instance.allowed_values).to match_array(expected)
      end
    end
  end

  it_behaves_like 'list_optional query filter' do
    let(:attribute) { :role_id }
    let(:model) { Member }
    let(:joins) { :member_roles }
    let(:valid_values) { [role1.id.to_s] }
  end
end
