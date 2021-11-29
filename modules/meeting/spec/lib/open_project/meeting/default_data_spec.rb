

require 'spec_helper'

describe OpenProject::Meeting::DefaultData, with_clean_fixture: true do
  let(:seeder) { BasicData::RoleSeeder.new }

  let(:roles) { [member, reader] }
  let(:member) { OpenProject::Meeting::DefaultData.member_role }
  let(:reader) { OpenProject::Meeting::DefaultData.reader_role }

  let(:member_permissions) { OpenProject::Meeting::DefaultData.member_permissions }
  let(:reader_permissions) { OpenProject::Meeting::DefaultData.reader_permissions }

  before do
    allow(seeder).to receive(:builtin_roles).and_return([])

    seeder.seed!
  end

  it 'adds permissions to the roles' do
    expect(member.permissions).to include *member_permissions
    expect(reader.permissions).to include *reader_permissions
  end

  it 'is not loaded again on existing data' do
    roles.each do |role|
      role.permissions = []
      role.save!
    end

    seeder.seed!
    roles.each(&:reload)

    expect(member.permissions).to be_empty
    expect(reader.permissions).to be_empty
  end
end
