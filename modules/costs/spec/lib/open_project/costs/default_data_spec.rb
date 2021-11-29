

require 'spec_helper'

describe Costs::DefaultData do
  let(:seeder) { BasicData::RoleSeeder.new }
  let(:member) { Costs::DefaultData.member_role }
  let(:permissions) { Costs::DefaultData.member_permissions }

  before do
    allow(seeder).to receive(:builtin_roles).and_return([])

    seeder.seed!
  end

  it 'adds permissions to the member role' do
    expect(member.permissions).to include *permissions
  end

  it 'is not loaded again on existing data' do
    member.permissions = []
    member.save!

    seeder.seed!
    member.reload

    expect(member.permissions).to be_empty
  end
end
