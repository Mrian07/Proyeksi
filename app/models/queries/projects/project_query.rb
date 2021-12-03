class Queries::Projects::ProjectQuery < Queries::BaseQuery
  include Queries::Serialization::Hash

  def self.model
    Project
  end

  def default_scope
    # Cannot simply use .visible here as it would
    # filter out archived projects for everybody.
    if User.current.admin?
      super
    else
      # Directly appending the .visible scope adds a
      # distinct which then requires every column used e.g. for ordering
      # to be in select.
      super.where(id: Project.visible)
    end
  end
end
