#-- encoding: UTF-8

class Queries::WorkPackages::Columns::WorkPackageColumn < Queries::Columns::Base
  attr_accessor :highlightable
  alias_method :highlightable?, :highlightable

  def initialize(name, options = {})
    super(name, options)
    self.highlightable = !!options.fetch(:highlightable, false)
  end

  def caption
    WorkPackage.human_attribute_name(name)
  end

  def self.scoped_column_sum(scope, select, group_by)
    scope = scope
              .except(:order, :select)

    if group_by
      scope
        .group(group_by)
        .select("#{group_by} id", select)
    else
      scope
        .select(select)
    end
  end
end
