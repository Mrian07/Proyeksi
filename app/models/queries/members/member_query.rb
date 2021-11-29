

class Queries::Members::MemberQuery < Queries::BaseQuery
  def self.model
    Member
  end

  def results
    super
      .includes(:roles, { principal: :preference }, :member_roles)
  end

  def default_scope
    Member.visible(User.current)
  end
end
