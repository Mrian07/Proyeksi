#-- encoding: UTF-8

# Filter for all work packages that are (or are not) required by work packages with the provided values.

class Queries::WorkPackages::Filter::RequiredFilter <
  Queries::WorkPackages::Filter::WorkPackageFilter
  include ::Queries::WorkPackages::Filter::FilterOnDirectedRelationsMixin

  def relation_type
    ::Relation::TYPE_REQUIRED
  end

  private

  def relation_filter
    { from_id: values }
  end

  def relation_select
    :to_id
  end
end
