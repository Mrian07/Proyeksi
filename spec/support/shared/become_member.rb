#-- encoding: UTF-8



module BecomeMember
  def self.included(base)
    base.send(:include, InstanceMethods)
  end

  module InstanceMethods
    def become_member_with_permissions(project, user, permissions = [])
      role = FactoryBot.create :role, permissions: Array(permissions)

      add_user_to_project! user: user, project: project, role: role
    end

    def add_user_to_project!(user:, project:, role: nil, permissions: nil)
      role ||= FactoryBot.create :existing_role, permissions: Array(permissions)
      FactoryBot.create :member, principal: user, project: project, roles: [role]
    end
  end
end
