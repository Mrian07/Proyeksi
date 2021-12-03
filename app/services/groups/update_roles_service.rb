

# Updates the roles of a membership assigned to the group.

module Groups
  class UpdateRolesService < ::BaseServices::BaseContracted
    include Groups::Concerns::MembershipManipulation

    def initialize(group, current_user:, contract_class: AdminOnlyContract)
      self.model = group

      super user: current_user,
            contract_class: contract_class
    end

    private

    def modify_members_and_roles(params)
      member = params.fetch(:member)

      sql_query = ::ProyeksiApp::SqlSanitization
                    .sanitize update_roles_cte,
                              group_id: model.id,
                              member_id: member.id,
                              project_id: member.project_id,
                              role_ids: member.role_ids

      execute_query(sql_query)
    end

    # rubocop:disable Metrics/AbcSize
    def update_roles_cte
      <<~SQL
        WITH
        -- select all users of the group
        group_users AS (
          SELECT user_id
          FROM #{GroupUser.table_name}
          WHERE group_id = :group_id
        ),
        -- select all members of the users of the group
        user_members AS (
          SELECT id
          FROM #{Member.table_name}
          WHERE user_id IN (SELECT user_id FROM group_users)
          AND project_id = :project_id
        ),
        -- select all member roles the group has for the member
        group_member_roles AS (
          SELECT member_roles.role_id AS role_id,
                 member_roles.id
          FROM #{MemberRole.table_name} member_roles
          WHERE member_roles.member_id = :member_id
        ),
        -- delete all roles assigned to users that group no longer has but keep those that the user
        -- has independently of the group (not inherited)
        remove_roles AS (
          DELETE FROM #{MemberRole.table_name}
          USING #{MemberRole.table_name} user_member_roles
          JOIN user_members ON user_members.id = user_member_roles.member_id
          LEFT JOIN group_member_roles ON user_member_roles.role_id = group_member_roles.role_id
          WHERE user_member_roles.inherited_from IS NOT NULL AND group_member_roles.role_id IS NULL
          AND member_roles.id = user_member_roles.id
          RETURNING #{MemberRole.table_name}.id, #{MemberRole.table_name}.member_id, #{MemberRole.table_name}.role_id
        ),
        -- add all roles to the user memberships
        add_roles AS (
          INSERT INTO #{MemberRole.table_name} (member_id, role_id, inherited_from)
          SELECT user_members.id, group_member_roles.role_id, group_member_roles.id
          FROM group_member_roles, user_members
          -- Ignore if role was already assigned
          ON CONFLICT DO NOTHING
          RETURNING member_id, role_id, id
        ),
        -- get all the member_roles that are duplicates of removed ones
        members_with_removed_roles AS (
          SELECT DISTINCT remove_roles.member_id
          FROM remove_roles
          WHERE NOT EXISTS
            (SELECT 1 FROM #{MemberRole.table_name}
              WHERE #{MemberRole.table_name}.member_id = remove_roles.member_id
              AND #{MemberRole.table_name}.role_id = remove_roles.role_id
              AND #{MemberRole.table_name}.id != remove_roles.id)
        ),
        -- get only the ids of members where roles have been added the member did not have before
        members_with_added_roles AS (
          SELECT DISTINCT add_roles.member_id
          FROM add_roles
          WHERE NOT EXISTS
            (SELECT 1 FROM #{MemberRole.table_name}
              WHERE #{MemberRole.table_name}.member_id = add_roles.member_id
              AND #{MemberRole.table_name}.role_id = add_roles.role_id
              AND #{MemberRole.table_name}.id != add_roles.id)
        )

        SELECT member_id from members_with_removed_roles
        UNION SELECT member_id from members_with_added_roles
      SQL
    end
    # rubocop:enable Metrics/AbcSize
  end
end
