

module Members
  class BaseContract < ::ModelContract
    delegate :principal,
             :project,
             :new_record?,
             to: :model

    attribute :roles

    validate :user_allowed_to_manage
    validate :roles_grantable
    validate :project_set
    validate :project_manageable

    def assignable_projects
      Project
        .active
        .where(id: Project.allowed_to(user, :manage_members))
    end

    private

    def user_allowed_to_manage
      errors.add :base, :error_unauthorized unless user_allowed_to_manage?
    end

    def roles_grantable
      unmarked_roles = model.member_roles.reject(&:marked_for_destruction?).map(&:role)

      errors.add(:roles, :ungrantable) unless unmarked_roles.all? { |r| role_grantable?(r) }
    end

    def project_set
      errors.add(:project, :blank) unless project_set_or_admin?
    end

    def project_manageable
      errors.add(:project, :invalid) unless project_manageable_or_blank?
    end

    def role_grantable?(role)
      role.builtin == Role::NON_BUILTIN &&
        ((model.project && role.instance_of?(Role)) || (!model.project && role.instance_of?(GlobalRole)))
    end

    def user_allowed_to_manage?
      user.allowed_to?(:manage_members,
                       model.project,
                       global: model.project.nil?)
    end

    def project_manageable_or_blank?
      !model.project || user.allowed_to?(:manage_members, model.project)
    end

    def project_set_or_admin?
      model.project || user.admin?
    end
  end
end
