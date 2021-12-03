class Queries::News::NewsQuery < Queries::BaseQuery
  def self.model
    News
  end

  def default_scope
    News.visible(User.current)
  end
end
