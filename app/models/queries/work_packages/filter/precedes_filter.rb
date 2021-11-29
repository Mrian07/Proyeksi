#-- encoding: UTF-8



# Filter for all work packages that are (or are not) predecessor of the provided values

class Queries::WorkPackages::Filter::PrecedesFilter <
  Queries::WorkPackages::Filter::WorkPackageFilter
  include ::Queries::WorkPackages::Filter::FilterOnDirectedRelationsMixin

  def relation_type
    ::Relation::TYPE_PRECEDES
  end

  private

  def relation_filter
    { from_id: values }
  end

  def relation_select
    :to_id
  end
end
