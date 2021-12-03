#-- encoding: UTF-8

module MembersHelper
  # Adds a link that either:
  # * sends a delete request to memberships in case only one role is assigned to the member
  # * sends a patch request to memberships in case there is more than one role assigned to the member
  #
  # If it is the later, the ids of the non delete roles are appended to the url so that they are kept.
  def global_member_role_deletion_link(member, role)
    if member.roles.length == 1
      link_to('',
              user_membership_path(user_id: member.user_id, id: member.id),
              { method: :delete, class: 'icon icon-delete', title: t(:button_delete) })
    else
      link_to('',
              user_membership_path(user_id: member.user_id, id: member.id, 'membership[role_ids]' => member.roles - [role]),
              { method: :patch, class: 'icon icon-delete', title: t(:button_delete) })
    end
  end
end
