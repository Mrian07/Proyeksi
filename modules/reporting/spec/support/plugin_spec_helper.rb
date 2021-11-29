

module OpenProject::Reporting
  module PluginSpecHelper
    def is_member(project, user, permissions = [])
      role = FactoryBot.create(:role, permissions: permissions)

      FactoryBot.create(:member, project: project,
                                 principal: user,
                                 roles: [role])
    end
  end
end
