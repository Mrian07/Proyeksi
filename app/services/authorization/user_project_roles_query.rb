#-- encoding: UTF-8



class Authorization::UserProjectRolesQuery < Authorization::UserRolesQuery
  transformations.register :all, :project_where_projection do |statement, user, _|
    statement.where(users_table[:id].eq(user.id))
  end

  transformations.register users_members_join, :project_id_limit do |statement, _, project|
    statement.and(members_table[:project_id].eq(project.id))
  end

  transformations.register roles_member_roles_join, :builtin_role do |statement, user, project|
    if project.public?
      builtin_role = if user.logged?
                       Role::BUILTIN_NON_MEMBER
                     else
                       Role::BUILTIN_ANONYMOUS
                     end

      builtin_role_condition = members_table[:id]
                               .eq(nil)
                               .and(roles_table[:builtin]
                                    .eq(builtin_role))

      statement = statement.or(builtin_role_condition)
    end

    statement
  end
end
