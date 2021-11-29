

require 'spec_helper'

describe OpenProject::Reporting::DefaultData do
  let(:seeder) { BasicData::RoleSeeder.new }
  let(:project_admin) { OpenProject::Reporting::DefaultData.project_admin_role }
  let(:permissions) do
    OpenProject::Reporting::DefaultData.restricted_project_admin_permissions
  end

  before do
    allow(seeder).to receive(:builtin_roles).and_return([])

    seeder.seed!
  end

  it 'removes permissions from the project admin role' do
    expect(project_admin.permissions).not_to include *permissions
  end

  it 'is not loaded again on existing data' do
    project_admin.add_permission! *permissions
    project_admin.save!

    # on existing data the permissions should not be removed
    seeder.seed!

    project_admin.reload
    expect(project_admin.permissions).to include *permissions
  end
end
