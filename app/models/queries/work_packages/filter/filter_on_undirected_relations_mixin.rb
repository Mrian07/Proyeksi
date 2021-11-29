#-- encoding: UTF-8



module Queries::WorkPackages::Filter::FilterOnUndirectedRelationsMixin
  include ::Queries::WorkPackages::Filter::FilterForWpMixin

  def where
    operator, junction = operator_and_junction

    <<-SQL
      #{WorkPackage.table_name}.id #{operator} (#{relations_subselect_from_to.to_sql})
      #{junction}
      #{WorkPackage.table_name}.id #{operator} (#{relations_subselect_to_from.to_sql})
    SQL
  end

  def relation_type
    raise NotImplementedError
  end

  private

  def operator_and_junction
    if operator_class == Queries::Operators::Equals
      %w[IN OR]
    else
      ['NOT IN', 'AND']
    end
  end

  def relations_subselect_to_from
    Relation
      .direct
      .send(relation_type)
      .where(to_id: values)
      .select(:from_id)
  end

  def relations_subselect_from_to
    Relation
      .direct
      .send(relation_type)
      .where(from_id: values)
      .select(:to_id)
  end
end
