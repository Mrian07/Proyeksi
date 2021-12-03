#-- encoding: UTF-8

class Authorization::AbstractUserQuery < Authorization::AbstractQuery
  transformations.register :all,
                           :users_members_join do |statement|
    statement
      .outer_join(members_table)
      .on(users_members_join)
  end

  transformations.register :all,
                           :member_roles_join,
                           after: [:users_members_join] do |statement|
    statement.outer_join(member_roles_table)
             .on(members_member_roles_join)
  end

  def self.members_member_roles_join
    members_table[:id].eq(member_roles_table[:member_id])
  end

  def self.users_members_join
    users_table[:id].eq(members_table[:user_id])
  end

  def self.members_table
    Member.arel_table
  end

  def self.users_table
    User.arel_table
  end

  def self.member_roles_table
    MemberRole.arel_table
  end

  def self.roles_table
    Role.arel_table
  end

  def self.role_permissions_table
    RolePermission.arel_table
  end
end
