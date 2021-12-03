#-- encoding: UTF-8

class Authorization::UserRolesQuery < Authorization::AbstractUserQuery
  self.model = Role
  self.base_table = users_table

  def self.query(*args)
    arel = transformed_query(*args)

    model.where(roles_table[:id].in(arel))
  end

  transformations.register :all, :roles_join do |statement|
    statement.outer_join(roles_table)
             .on(roles_member_roles_join)
  end

  transformations.register :all, :project do |statement|
    statement.project(roles_table[:id])
  end

  def self.roles_member_roles_join
    roles_table[:id].eq(member_roles_table[:role_id])
  end
end
