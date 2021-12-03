class Queries::Queries::QueryQuery < Queries::BaseQuery
  def self.model
    Query
  end

  def default_scope
    Query.visible(to: user)
  end
end
