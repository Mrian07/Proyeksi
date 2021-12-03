class Queries::Principals::PrincipalQuery < Queries::BaseQuery
  def self.model
    Principal
  end

  def default_scope
    Principal.not_builtin
  end
end
