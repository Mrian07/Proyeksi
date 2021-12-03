class Mails::MemberCreatedJob < Mails::MemberJob
  private

  alias_method :send_for_project_user, :send_added_project

  def send_for_group_user(current_user, user_member, group_member, message)
    if new_roles_added?(user_member, group_member)
      send_updated_project(current_user, user_member, message)
    elsif all_roles_added?(user_member, group_member)
      send_added_project(current_user, user_member, message)
    end
  end

  def new_roles_added?(user_member, group_member)
    (group_member.member_roles.map(&:id) - user_member.member_roles.map(&:inherited_from)).length <
      group_member.member_roles.length && user_member.member_roles.any? { |mr| mr.inherited_from.nil? }
  end

  def all_roles_added?(user_member, group_member)
    (user_member.member_roles.map(&:inherited_from) - group_member.member_roles.map(&:id)).empty?
  end
end
