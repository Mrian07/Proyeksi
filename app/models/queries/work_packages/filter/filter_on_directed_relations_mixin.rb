#-- encoding: UTF-8



module Queries::WorkPackages::Filter::FilterOnDirectedRelationsMixin
  include ::Queries::WorkPackages::Filter::FilterForWpMixin

  def where
    # The order in which we call the methods on `Relation` matters, as
    # the `Relation`'s association `includes` is overwritten with the method `includes`
    # otherwise.
    relations_subselect = Relation
                          .send(normalized_relation_type)
                          .direct
                          .where(relation_filter)
                          .select(relation_select)

    operator = if operator_class == Queries::Operators::Equals
                 'IN'
               else
                 'NOT IN'
               end

    "#{WorkPackage.table_name}.id #{operator} (#{relations_subselect.to_sql})"
  end

  def relation_type
    raise NotImplementedError
  end

  def normalized_relation_type
    ::Relation.canonical_type relation_type
  end

  private

  def relation_filter
    raise NotImplementedError
  end

  def relation_select
    raise NotImplementedError
  end
end
