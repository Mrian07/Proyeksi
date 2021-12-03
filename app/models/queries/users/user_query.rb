class Queries::Users::UserQuery < Queries::BaseQuery
  def self.model
    User
  end

  def default_scope
    # This seemingly duplication is necessary because of the builtin classes
    # * SystemUser
    # * DeletedUser
    # * AnonymousUser
    # inheriting from user. Without it, instances of those classes would show up.
    User.user
  end
end
