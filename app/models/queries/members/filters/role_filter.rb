#-- encoding: UTF-8

class Queries::Members::Filters::RoleFilter < Queries::Members::Filters::MemberFilter
  def allowed_values
    @allowed_values ||= begin
                          Role.pluck(:name, :id).map { |name, id| [name, id] }
                        end
  end

  def type
    :list_optional
  end

  def self.key
    :role_id
  end

  def joins
    :member_roles
  end

  def where
    operator_strategy.sql_for_field(values, 'member_roles', 'role_id')
  end
end
