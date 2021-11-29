

class Queries::Groups::GroupQuery < Queries::BaseQuery
  def self.model
    Group
  end

  def default_scope
    Group.visible(User.current)
  end
end
