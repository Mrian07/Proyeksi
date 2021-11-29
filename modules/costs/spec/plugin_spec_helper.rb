

module Cost
  module PluginSpecHelper
    def is_member(project, user, permissions = [])
      role = ::FactoryBot.create(:role, permissions: permissions)

      ::FactoryBot.create(:member, project: project,
                                   principal: user,
                                   roles: [role])
      user.reload
    end
  end
end
