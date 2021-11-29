#-- encoding: UTF-8



# Filter for all work packages that are (or are not) duplicated by work packages with the provided values.

class Queries::WorkPackages::Filter::DuplicatedFilter <
  Queries::WorkPackages::Filter::WorkPackageFilter
  include ::Queries::WorkPackages::Filter::FilterOnDirectedRelationsMixin

  def relation_type
    ::Relation::TYPE_DUPLICATED
  end

  private

  def relation_filter
    { from_id: values }
  end

  def relation_select
    :to_id
  end
end
