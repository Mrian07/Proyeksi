#-- encoding: UTF-8



# Filter for all work packages that are (or are not) followers of the provided values

class Queries::WorkPackages::Filter::FollowsFilter <
  Queries::WorkPackages::Filter::WorkPackageFilter
  include ::Queries::WorkPackages::Filter::FilterOnDirectedRelationsMixin

  def relation_type
    ::Relation::TYPE_FOLLOWS
  end

  private

  def relation_filter
    { to_id: values }
  end

  def relation_select
    :from_id
  end
end
