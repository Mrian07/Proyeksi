#-- encoding: UTF-8

module Groups
  class AddUsersService < ::BaseServices::BaseContracted
    include Groups::Concerns::MembershipManipulation

    def initialize(group, current_user:, contract_class: AdminOnlyContract)
      self.model = group

      super user: current_user,
            contract_class: contract_class
    end

    private

    def modify_members_and_roles(params)
      sql_query = ::ProyeksiApp::SqlSanitization
                    .sanitize add_to_user_and_projects_cte,
                              group_id: model.id,
                              user_ids: params[:ids]

      execute_query(sql_query)
    end

    def add_to_user_and_projects_cte
      <<~SQL
        -- select existing users from given IDs
        WITH found_users AS (
          SELECT id as user_id FROM #{User.table_name} WHERE id IN (:user_ids)
        ),
        timestamp AS (
          SELECT CURRENT_TIMESTAMP as time
        ),
        -- select existing memberships of the group
        group_memberships AS (
          SELECT project_id, user_id FROM #{Member.table_name} WHERE user_id = :group_id
        ),
        -- select existing member_roles of the group
        group_roles AS (
          SELECT members.project_id AS project_id,
                 members.user_id AS user_id,
                 members.id AS member_id,
                 member_roles.role_id AS role_id,
                 member_roles.id AS member_role_id
          FROM #{MemberRole.table_name} member_roles
          JOIN #{Member.table_name} members
          ON members.id = member_roles.member_id AND members.user_id = :group_id
        ),
        -- insert into group_users association
        new_group_users AS (
          INSERT INTO group_users (group_id, user_id)
          SELECT :group_id as group_id, user_id FROM found_users
          ON CONFLICT DO NOTHING
        ),
        -- find members that already exist
        existing_members AS (
          SELECT members.id, found_users.user_id, members.project_id
          FROM members, found_users, group_memberships
          WHERE members.user_id = found_users.user_id
          AND members.project_id = group_memberships.project_id
          AND members.id IS NOT NULL
        ),
        -- insert the group user into members
        new_members AS (
          INSERT INTO #{Member.table_name} (project_id, user_id, updated_at, created_at)
          SELECT group_memberships.project_id, found_users.user_id, (SELECT time from timestamp), (SELECT time from timestamp)
          FROM found_users, group_memberships
          WHERE NOT EXISTS (SELECT 1 FROM existing_members WHERE existing_members.user_id = found_users.user_id AND existing_members.project_id = group_memberships.project_id)
          ON CONFLICT(project_id, user_id) DO NOTHING
          RETURNING id, user_id, project_id
        ),
        -- copy the member roles of the group
        add_roles AS (
          INSERT INTO #{MemberRole.table_name} (member_id, role_id, inherited_from)
          SELECT members.id, group_roles.role_id, group_roles.member_role_id
          FROM group_roles
          JOIN
            (SELECT * FROM new_members UNION SELECT * from existing_members) members ON group_roles.project_id = members.project_id
          -- Ignore if the role was already inserted by us
          ON CONFLICT DO NOTHING
          RETURNING id, member_id, role_id
        ),
        -- get the ids of members where roles have been added the member did not have before
        members_with_added_roles AS (
          SELECT DISTINCT add_roles.member_id
          FROM add_roles
          WHERE NOT EXISTS
            (SELECT 1 FROM #{MemberRole.table_name}
              WHERE #{MemberRole.table_name}.member_id = add_roles.member_id
              AND #{MemberRole.table_name}.role_id = add_roles.role_id
              AND #{MemberRole.table_name}.id != add_roles.id)
        ),
        touch_existing_members AS (
          UPDATE members SET updated_AT = CURRENT_TIMESTAMP
          WHERE id IN (SELECT id from existing_members)
          AND id IN (SELECT member_id from members_with_added_roles)
        )

        SELECT member_id from members_with_added_roles
      SQL
    end

    def touch_updated(member_ids)
      # do nothing in this case as we already touch while updating
    end
  end
end
