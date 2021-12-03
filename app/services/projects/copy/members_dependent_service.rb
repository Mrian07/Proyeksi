#-- encoding: UTF-8

module Projects::Copy
  class MembersDependentService < Dependency
    def self.human_name
      I18n.t(:label_member_plural)
    end

    def source_count
      source.members.count
    end

    protected

    def copy_dependency(*)
      # Copy users and placeholder users first,
      # then groups to handle members with inherited and given roles
      source.memberships.sort_by { |m| m.principal.is_a?(Group) ? 1 : 0 }.each do |member|
        create_membership(member)
      end
    end

    def create_membership(member)
      # only copy non inherited roles
      # inherited roles will be added when copying the group membership
      role_ids = member.member_roles.reject(&:inherited?).map(&:role_id)

      return if role_ids.empty?

      attributes = member
                     .attributes.dup.except('id', 'project_id', 'created_at', 'updated_at')
                     .merge(role_ids: role_ids,
                            project: target,
                            # This is magic for now. The settings has been set before in the Projects::CopyService
                            # It would be better if this was not sneaked in but rather passed in as a parameter.
                            send_notifications: ActionMailer::Base.perform_deliveries)

      Members::CreateService
        .new(user: User.current, contract_class: EmptyContract)
        .call(attributes)
    end
  end
end
