#-- encoding: UTF-8



class Groups::UpdateService < ::BaseServices::Update
  protected

  def persist(call)
    removed_users = groups_removed_users(call.result)
    member_roles = member_roles_to_prune(removed_users)
    project_ids = member_roles.pluck(:project_id)
    member_role_ids = member_roles.pluck(:id)

    call = super

    remove_member_roles(member_role_ids)
    cleanup_members(removed_users, project_ids)

    call
  end

  def after_perform(call)
    new_user_ids = call.result.group_users.select(&:saved_changes?).map(&:user_id)

    if new_user_ids.any?
      db_call = ::Groups::AddUsersService
                  .new(call.result, current_user: user)
                  .call(ids: new_user_ids)

      call.add_dependent!(db_call)
    end

    call
  end

  def groups_removed_users(group)
    group.group_users.select(&:marked_for_destruction?).map(&:user).compact
  end

  def remove_member_roles(member_role_ids)
    ::Groups::CleanupInheritedRolesService
      .new(model, current_user: user)
      .call(member_role_ids: member_role_ids)
  end

  def member_roles_to_prune(users)
    return MemberRole.none if users.empty?

    MemberRole
      .includes(member: :member_roles)
      .where(inherited_from: model.members.joins(:member_roles).select('member_roles.id'))
      .where(members: { user_id: users.map(&:id) })
  end

  def cleanup_members(users, project_ids)
    Members::CleanupService
      .new(users, project_ids)
      .call
  end
end
