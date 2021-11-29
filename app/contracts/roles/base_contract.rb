

module Roles
  class BaseContract < ::ModelContract
    attribute :name
    attribute :assignable

    validate :check_permission_prerequisites

    def assignable_permissions
      if model.is_a?(GlobalRole)
        assignable_global_permissions
      else
        assignable_member_permissions
      end
    end

    private

    def assignable_member_permissions
      permissions_to_remove = case model.builtin
                              when Role::BUILTIN_NON_MEMBER
                                OpenProject::AccessControl.members_only_permissions
                              when Role::BUILTIN_ANONYMOUS
                                OpenProject::AccessControl.loggedin_only_permissions
                              else
                                []
                              end

      OpenProject::AccessControl.permissions -
        OpenProject::AccessControl.public_permissions -
        OpenProject::AccessControl.global_permissions -
        permissions_to_remove
    end

    def assignable_global_permissions
      OpenProject::AccessControl.global_permissions
    end

    def check_permission_prerequisites
      model.permissions.each do |name|
        permission = OpenProject::AccessControl.permission(name)

        next unless permission

        unmet_dependencies = permission.dependencies - model.permissions

        unmet_dependencies.each do |unmet_dependency|
          add_unmet_dependency_error(name, unmet_dependency)
        end
      end
    end

    def add_unmet_dependency_error(selected, unmet)
      errors.add(:permissions,
                 :dependency_missing,
                 permission: I18n.t("permission_#{selected}"),
                 dependency: I18n.t("permission_#{unmet}"))
    end
  end
end
