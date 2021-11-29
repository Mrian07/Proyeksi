#-- encoding: UTF-8



class Queries::WorkPackages::Filter::RelatableFilter < Queries::WorkPackages::Filter::WorkPackageFilter
  include Queries::WorkPackages::Filter::FilterForWpMixin

  def available?
    User.current.allowed_to?(:manage_work_package_relations, nil, global: true)
  end

  def type
    :relation
  end

  def type_strategy
    @type_strategy ||= Queries::Filters::Strategies::Relation.new(self)
  end

  def where
    # all of the filter logic is handled by #scope
    "(1 = 1)"
  end

  def scope
    if operator == Relation::TYPE_RELATES
      relateable_from_or_to
    elsif operator != 'parent' && canonical_operator == operator
      relateable_to
    else
      relateable_from
    end
  end

  private

  def relateable_from_or_to
    relateable_to.or(relateable_from)
  end

  def relateable_from
    WorkPackage.relateable_from(from)
  end

  def relateable_to
    WorkPackage.relateable_to(from)
  end

  def from
    WorkPackage.find(values.first)
  end

  def canonical_operator
    Relation.canonical_type(operator)
  end
end
