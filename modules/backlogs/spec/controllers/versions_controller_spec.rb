

require 'spec_helper'

describe VersionsController, type: :controller do
  let(:version) do
    FactoryBot.create(:version,
                      sharing: 'system')
  end

  let(:other_project) do
    FactoryBot.create(:project).tap do |p|
      FactoryBot.create(:member,
                        user: current_user,
                        roles: [FactoryBot.create(:role, permissions: [:manage_versions])],
                        project: p)
    end
  end

  let(:current_user) do
    FactoryBot.create(:user,
                      member_in_project: version.project,
                      member_with_permissions: [:manage_versions])
  end

  before do
    # Create a version assigned to a project
    @oldVersionName = version.name
    @newVersionName = 'NewVersionName'

    # Create params to update version
    @params = {}
    @params[:id] = version.id
    @params[:version] = { name: @newVersionName }
  end

  before do
    login_as current_user
  end

  describe 'update' do
    it 'does not allow to update versions from different projects' do
      @params[:project_id] = other_project.id
      patch 'update', params: @params
      version.reload

      expect(response).to redirect_to project_settings_versions_path(other_project)
      expect(version.name).to eq(@oldVersionName)
    end

    it 'allows to update versions from the version project' do
      @params[:project_id] = version.project.id
      patch 'update', params: @params
      version.reload

      expect(response).to redirect_to project_settings_versions_path(version.project)
      expect(version.name).to eq(@newVersionName)
    end
  end
end
