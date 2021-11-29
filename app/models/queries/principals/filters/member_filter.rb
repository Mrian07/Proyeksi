#-- encoding: UTF-8



class Queries::Principals::Filters::MemberFilter < Queries::Principals::Filters::PrincipalFilter
  def allowed_values
    Project.active.all.map do |project|
      [project.name, project.id]
    end
  end

  def type
    :list_optional
  end

  def self.key
    :member
  end

  def scope
    case operator
    when '='
      Principal.in_project(values)
    when '!'
      Principal.not_in_project(values)
    when '*'
      member_included_scope.where.not(members: { id: nil })
    when '!*'
      member_included_scope.where.not(id: Member.distinct(:user_id).select(:user_id))
    end
  end

  private

  def member_included_scope
    Principal.includes(:members)
  end
end
