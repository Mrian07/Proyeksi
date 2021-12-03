#-- encoding: UTF-8

class Authorization::UserGlobalRolesQuery < Authorization::UserRolesQuery
  transformations.register roles_member_roles_join,
                           :builtin_role do |statement, user|
    builtin_role = if user.logged?
                     Role::BUILTIN_NON_MEMBER
                   else
                     Role::BUILTIN_ANONYMOUS
                   end

    builtin_role_condition = roles_table[:builtin].eq(builtin_role)

    statement.or(builtin_role_condition)
  end

  transformations.register :all, :global_group_where_projection do |statement, user|
    statement.group(roles_table[:id])
             .where(users_table[:id].eq(user.id))
  end
end
