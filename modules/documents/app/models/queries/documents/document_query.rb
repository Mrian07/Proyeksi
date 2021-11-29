

class Queries::Documents::DocumentQuery < Queries::BaseQuery
  def self.model
    Document
  end

  def default_scope
    Document.visible(User.current)
  end
end
