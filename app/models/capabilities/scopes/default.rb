#-- encoding: UTF-8

module Capabilities::Scopes
  module Default
    extend ActiveSupport::Concern

    class_methods do
      # Currently, this does not reflect the behaviour present in the backend that every permission in at least one project
      # leads to having that permission in the global context as well. Hopefully, this is not necessary to be added.
      def default
        capabilities_sql = <<~SQL
          (
            #{default_sql_by_member}
            UNION
            #{default_sql_by_non_member}
            UNION
            #{default_sql_by_admin}
          ) capabilities
        SQL

        select('capabilities.*')
          .from(capabilities_sql)
      end

      private

      def default_sql_by_member
        <<~SQL
          SELECT DISTINCT
            actions.id "action",
            users.id principal_id,
            projects.id context_id
          FROM (#{Action.default.to_sql}) actions
          LEFT OUTER JOIN "role_permissions" ON "role_permissions"."permission" = "actions"."permission"
          LEFT OUTER JOIN "roles" ON "roles".id = "role_permissions".role_id
          LEFT OUTER JOIN "member_roles" ON "member_roles".role_id = "roles".id
          LEFT OUTER JOIN "members" ON members.id = member_roles.member_id
          JOIN (#{Principal.visible.not_builtin.not_locked.to_sql}) users
            ON "users".id = members.user_id
          LEFT OUTER JOIN "projects"
            ON "projects".id = members.project_id
          LEFT OUTER JOIN enabled_modules
             ON enabled_modules.project_id = projects.id
             AND actions.module = enabled_modules.name
          WHERE (projects.active AND (enabled_modules.project_id IS NOT NULL OR "actions".module IS NULL))
          OR (projects.id IS NULL AND "actions".global)
        SQL
      end

      def default_sql_by_admin
        <<~SQL
          SELECT DISTINCT
            actions.id "action",
            users.id principal_id,
            projects.id context_id
          FROM (#{Action.default.to_sql}) actions
          JOIN (#{Principal.visible.not_builtin.not_locked.to_sql}) users
            ON "users".admin = true
          LEFT OUTER JOIN "projects"
            ON "projects".active = true
            AND NOT "actions".global
          LEFT OUTER JOIN enabled_modules
            ON enabled_modules.project_id = projects.id
            AND actions.module = enabled_modules.name
          WHERE (projects.id IS NOT NULL AND (enabled_modules.project_id IS NOT NULL OR "actions".module IS NULL)) OR "actions".global
        SQL
      end

      def default_sql_by_non_member
        <<~SQL
          SELECT DISTINCT
            actions.id "action",
            users.id principal_id,
            projects.id context_id
          FROM (#{Action.default.to_sql}) actions
          JOIN "role_permissions" ON "role_permissions"."permission" = "actions"."permission"
          JOIN "roles" ON "roles".id = "role_permissions".role_id AND roles.builtin = #{Role::BUILTIN_NON_MEMBER}
          JOIN (#{Principal.visible.not_builtin.not_locked.to_sql}) users
            ON 1 = 1
          JOIN "projects"
            ON "projects".active = true
            AND ("projects".public = true OR EXISTS (SELECT 1
                                                     FROM members
                                                     WHERE members.project_id = projects.id
                                                     AND members.user_id = users.id
                                                     LIMIT 1))
          LEFT OUTER JOIN enabled_modules
            ON enabled_modules.project_id = projects.id
            AND actions.module = enabled_modules.name

          WHERE enabled_modules.project_id IS NOT NULL OR "actions".module IS NULL
        SQL
      end
    end
  end
end
