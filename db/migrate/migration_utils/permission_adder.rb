#-- encoding: UTF-8



module Migration
  module MigrationUtils
    class PermissionAdder
      def self.add(having, add)
        Role
          .joins(:role_permissions)
          .where(role_permissions: { permission: having.to_s })
          .references(:role_permissions)
          .find_each do |role|
          role.add_permission! add
        end
      end
    end
  end
end
