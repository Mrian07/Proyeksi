class Queries::Actions::ActionQuery < Queries::BaseQuery
  def self.model
    Action
  end

  def results
    super
      .reorder(id: :asc)
  end

  def default_scope
    Action
      .default
      .distinct
  end
end
